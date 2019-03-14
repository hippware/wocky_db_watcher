defmodule WockyDBWatcher.Watcher do
  @moduledoc """
  This module implementes the GenStage producer for DB callback events.
  Tables that you want events for must have appropriate triggers and functions
  created. @see Wocky.Repo.Migration.Utils
  """

  defmodule State do
    @moduledoc "The state of the watcher"

    defstruct [
      :ref,
      :channel,
      :backend,
      :pending
    ]
  end

  use GenServer

  require Logger

  alias Postgrex.Notifications
  alias WockyDBWatcher.Event
  alias WockyDBWatcher.Watcher.State

  @batch_timeout 50
  @max_batch 10

  @type action :: :insert | :update | :delete

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    backend =
      :wocky_db_watcher
      |> Confex.get_env(:backend, WockyDBWatcher.Backend.SQS)

    backend.init

    channel = Confex.fetch_env!(:wocky_db_watcher, :channel)

    ref = Notifications.listen!(:watcher_notifications, channel)

    {:ok,
     %State{
       ref: ref,
       channel: channel,
       backend: backend,
       pending: []
     }}
  end

  def handle_info(
        {:notification, _, ref, channel, payload},
        %State{ref: ref, channel: channel} = state
      ) do

    j = parse(payload)

    result = Postgrex.query!(
      :watcher_postgrex,
      "DELETE FROM watcher_events WHERE id = $1 RETURNING payload",
      [j.id])

    if (result.num_rows == 1) do
      full_event = parse(hd(result.rows))

      %Event{
        table: full_event.table,
        action: String.to_atom(full_event.action),
      }
      |> maybe_add_rec(:old, full_event)
      |> maybe_add_rec(:new, full_event)
      |> send_or_enqueue(state)
    else
      {:noreply, state}
    end
  end

  def handle_info(:timeout, state), do: flush(state)

  def handle_info(_info, state), do: {:noreply, state}

  defp maybe_add_rec(event, field, map) do
    case Map.get(map, field) do
      nil -> event
      rec -> Map.put(event, field, rec)
    end
  end

  defp send_or_enqueue(msg, %{pending: pending} = state)
       when length(pending) == @max_batch - 1 do
    flush(%{state | pending: [encode(msg) | pending]})
  end

  defp send_or_enqueue(msg, %{pending: pending} = state) do
    {:noreply, %{state | pending: [encode(msg) | pending]}, @batch_timeout}
  end

  defp flush(%State{pending: pending, backend: backend} = state) do
    pending
    |> Enum.reverse()
    |> backend.send

    {:noreply, %{state | pending: []}}
  end

  # Ideally we'd use 'atoms!' here, but we don't actually know all the object
  # keys since we can't include the wocky app.
  defp parse(payload), do: Poison.decode!(payload, keys: :atoms)

  defp encode(data), do: Poison.encode!(data)
end
