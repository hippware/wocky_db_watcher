defmodule WockyDBWatcher.Backend.Direct do
  @moduledoc """
  The Direct backend for the wocky DB watcher. This is used only for testing
  in development where SQS is not available.
  """

  use GenServer

  @behaviour WockyDBWatcher.Backend

  def init do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
    :ok
  end

  def init(_) do
    {:ok, {[], []}}
  end

  def send(messages), do: GenServer.cast(__MODULE__, {:send, messages})

  def recv, do: GenServer.call(__MODULE__, :recv, :infinity)

  def delete(_), do: :ok

  def flush, do: GenServer.call(__MODULE__, :flush)

  def has_events, do: GenServer.call(__MODULE__, :has_events)

  def handle_cast({:send, messages}, {[], [waiter | rest]}) do
    GenServer.reply(waiter, {:ok, transform_messages(messages)})
    {:noreply, {[], rest}}
  end

  def handle_cast({:send, messages}, {queue, []}) do
    {:noreply, {queue ++ transform_messages(messages), []}}
  end

  def handle_call(:recv, from, {[], waiters}) do
    {:noreply, {[], [from | waiters]}}
  end

  def handle_call(:recv, _from, {messages, []}) do
    {:reply, {:ok, messages}, {[], []}}
  end

  def handle_call(:has_events, _from, {messages, _} = state) do
    {:reply, length(messages) != 0, state}
  end

  def handle_call(:flush, _from, _) do
    {:reply, :ok, {[], []}}
  end

  defp transform_messages(messages) do
    Enum.map(messages, fn m -> %{body: m} end)
  end
end
