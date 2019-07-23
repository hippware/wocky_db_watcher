# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :dawdle,
  start_pollers: false,
  backend: Dawdle.Backend.SQS

config :dawdle_db, channel: "wocky_db_watcher_notify"

config :dawdle_db, :db,
  database: {:system, :string, "WOCKY_DB_NAME", "wocky"},
  username: {:system, :string, "WOCKY_DB_USER", "postgres"},
  password: {:system, :string, "WOCKY_DB_PASSWORD", "password"},
  hostname: {:system, :string, "WOCKY_DB_HOST", "localhost"},
  port: {:system, :integer, "WOCKY_DB_PORT", 5432},
  pool_size: {:system, :integer, "WOCKY_DB_POOL_SIZE", 15}

if Mix.env() == :prod do
  config :ex_aws,
    access_key_id: :instance_role,
    secret_access_key: :instance_role
else
  config :ex_aws,
    access_key_id: [
      {:system, "AWS_ACCESS_KEY_ID"},
      {:awscli, "default", 30}
    ],
    secret_access_key: [
      {:system, "AWS_SECRET_ACCESS_KEY"},
      {:awscli, "default", 30}
    ]
end
