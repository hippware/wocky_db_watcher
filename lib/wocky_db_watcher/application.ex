defmodule WockyDBWatcher.Application do
  @moduledoc """
  The Wocky DB Watcher Service.
  """
  use Application

  alias Postgrex.Notifications
  alias WockyDBWatcher.Watcher

  def start(_type, _args) do
    config =
      :wocky_db_watcher
      |> Confex.fetch_env!(:db)
      |> Keyword.drop([:pool])

    Supervisor.start_link(
      [
        %{id: Postgrex,
          start: {Postgrex, :start_link, [Keyword.put(config, :name, :watcher_postgrex)]}
        },
        %{id: Notifications,
          start: {Notifications, :start_link, [Keyword.put(config, :name, :watcher_notifications)]}
        },
        %{id: Watcher,
          start: {Watcher, :start_link, []}
        }
      ],
      strategy: :rest_for_one,
      name: WockyDBWatcher.Supervisor
    )
  end
end
