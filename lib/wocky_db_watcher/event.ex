defmodule WockyDBWatcher.Event do
  @moduledoc """
  Strcut containing an event from the DB watcher
  """

  defstruct [
    :table,
    :action,
    :old,
    :new
  ]

  @type t :: %__MODULE__{}
end
