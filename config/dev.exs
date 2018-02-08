use Mix.Config

config :wocky_db_watcher, Wocky.Repo, database: "wocky_dev"

config :wocky_db_watcher, backend: WockyDBWatcher.Backend.Direct
