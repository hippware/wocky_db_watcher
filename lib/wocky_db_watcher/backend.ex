defmodule WockyDBWatcher.Backend do
  @moduledoc """
  Behaviour module for wocky DB watcher backend implementations
  """

  @type send_message :: binary()
  @type recv_message :: map()

  @callback init() :: :ok
  @callback send([send_message()]) :: :ok | {:error, term()}
  @callback recv() :: {:ok, [recv_message()]} | {:error, term()}
  @callback delete([recv_message()]) :: :ok
end
