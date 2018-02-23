defmodule WockyDBWatcher.Backend.SQS do
  alias ExAws.SQS

  @behaviour WockyDBWatcher.Backend
  @group_id "wocky_db_watcher"

  def init, do: :ok

  def send([message]) do
    queue()
    |> SQS.send_message(
      message,
      message_group_id: @group_id,
      message_deduplication_id: id()
    )
    |> ExAws.request(aws_config())
    |> IO.inspect()
  end

  def send(messages) do
    queue()
    |> SQS.send_message_batch(batchify(messages))
    |> ExAws.request(aws_config())
    |> IO.inspect()
  end

  def recv do
    result =
      queue()
      |> SQS.receive_message()
      |> ExAws.request(aws_config())

    case result do
      {:ok, %{body: %{messages: []}}} -> recv()
      {:ok, %{body: %{messages: messages}}} -> messages
    end
  end

  def delete(messages) do
    {del_list, _} =
      Enum.map_reduce(messages, 0, fn m, id ->
        {%{id: Integer.to_string(id), receipt_handle: m.receipt_handle}, id + 1}
      end)

    queue()
    |> SQS.delete_message_batch(del_list)
    |> ExAws.request(aws_config())

    :ok
  end

  defp queue, do: config(:queue)

  defp aws_config, do: [region: config(:region)]

  defp config(term) do
    :wocky_db_watcher
    |> Confex.fetch_env!(__MODULE__)
    |> Keyword.get(term)
  end

  defp id do
    [:monotonic]
    |> :erlang.unique_integer()
    |> Integer.to_string()
  end

  defp batchify(messages) do
    Enum.map(messages, fn m ->
      id = id()
      [id: id,
       message_body: m,
       message_deduplication_id: id,
       message_group_id: @group_id]
    end)
  end
end
