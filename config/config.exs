import Config


config :file_watch_example, :ecto_repos, [Store]
config :file_watch_example, Store,
  database: "store",
  username: "test",
  password: "test",
  hostname: "db",
  pool_size: 100,
  migration_timestamps: [type: :utc_datetime_usec],
  migration_lock: nil,
  queue_target: 10_000

config :logger, :console,
  level: :debug,
  format: "[$level] $message $metadata\n",
  metadata: [:error_code, :file]

config :logger,
  backends: [{LoggerFileBackend, :debug}]

config :logger, :debug,
  path: "/var/log/elixir_app/debug.log",
  level: :debug
