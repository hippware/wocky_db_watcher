defmodule WockyDBWatcher.Application do
  @moduledoc """
  The Wocky DB Watcher Service.
  """
  use Application

  alias WockyDBWatcher.Watcher

  def start(_type, _args) do
    Supervisor.start_link(
      [
        %{id: Watcher,
          start: {Watcher, :start_link, []}
        }
      ],
      strategy: :one_for_one,
      name: WockyDBWatcher.Supervisor
    )
  end
end
