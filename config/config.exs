# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :wocky_db_watcher, :db,
  database: {:system, :string, "WOCKY_DB_NAME", "wocky"},
  username: {:system, :string, "WOCKY_DB_USER", "postgres"},
  password: {:system, :string, "WOCKY_DB_PASSWORD", "password"},
  hostname: {:system, :string, "WOCKY_DB_HOST", "localhost"},
  port: {:system, :integer, "WOCKY_DB_PORT", 5432},
  pool_size: {:system, :integer, "WOCKY_DB_POOL_SIZE", 15}

config :wocky_db_watcher,
  channel: "wocky_db_watcher_notify"

config :wocky_db_watcher, WockyDBWatcher.Backend.SQS,
  region: {:system, :string, "WOCKY_DB_WATCHER_REGION"},
  queue: {:system, :string, "WOCKY_DB_WATCHER_QUEUE"}

import_config "#{Mix.env()}.exs"

# Configure release generation
config :distillery,
  no_warn_missing: [
    :distillery,
    :dialyxir,
    :parse_trans
  ]
