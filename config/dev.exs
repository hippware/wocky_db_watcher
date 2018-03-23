use Mix.Config

config :wocky_db_watcher, :db,
  database: "wocky_dev"

config :wocky_db_watcher, backend: WockyDBWatcher.Backend.Direct
