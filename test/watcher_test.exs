defmodule WockyDBWatcher.WatcherTest do
  use ExUnit.Case, async: false

  alias WockyDBWatcher.MigrationUtils

  @db :watcher_postgrex

  setup do
    {:ok, _} = Application.ensure_all_started(:wocky_db_watcher)

    create_table()

    on_exit(fn ->
      Postgrex.query(@db, "DROP TABLE t", [])
    end)
    {:ok, backend: Confex.get_env(:wocky_db_watcher, :backend)}
  end

  test "test a simple notification", ctx do
    {:ok, _} = Postgrex.query(@db, "INSERT INTO t (id, val) VALUES (1, 'a')", [])

    assert {:ok, [%{body: _}]} = ctx.backend.recv()
  end

  test "kill notifications process", ctx do
    :erlang.exit(:erlang.whereis(:watcher_notifications), :kill)
    :timer.sleep(500)

    {:ok, _} = Postgrex.query(@db, "INSERT INTO t (id, val) VALUES (1, 'a')", [])

    assert {:ok, [%{body: _}]} = ctx.backend.recv()
  end

  defp create_table do
    {:ok, _} = Postgrex.query(@db, "DROP TABLE IF EXISTS t", [])
    {:ok, _} = Postgrex.query(@db,
      """
      CREATE TABLE t (
        id integer,
        val text
      );
      """,
    [])

    MigrationUtils.create_trigger("t", :insert)
  end
end
