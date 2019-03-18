defmodule WockyDBWatcher.Application do
  @moduledoc """
  The Wocky DB Watcher Service.
  """
  use Application

  def start(_type, _args) do
    DawdleDB.Watcher.Supervisor.start_link()
  end
end
