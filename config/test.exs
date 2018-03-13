use Mix.Config

# Notification DB config
config :wocky_db_watcher, :db,
  database: "wocky_test"

config :wocky_db_watcher, backend: WockyDBWatcher.Backend.Direct
