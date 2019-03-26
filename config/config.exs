# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :dawdle,
  start_listener: false,
  backend: Dawdle.Backend.SQS

config :dawdle_db, channel: "wocky_db_watcher_notify"

config :dawdle_db, :db,
  database: {:system, :string, "WOCKY_DB_NAME", "wocky"},
  username: {:system, :string, "WOCKY_DB_USER", "postgres"},
  password: {:system, :string, "WOCKY_DB_PASSWORD", "password"},
  hostname: {:system, :string, "WOCKY_DB_HOST", "localhost"},
  port: {:system, :integer, "WOCKY_DB_PORT", 5432},
  pool_size: {:system, :integer, "WOCKY_DB_POOL_SIZE", 15}
