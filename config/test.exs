use Mix.Config

# Notification DB config
config :wocky_db_watcher, :db,
  database: "wocky_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :wocky_db_watcher, backend: Wocky.Watcher.Backend.Direct
