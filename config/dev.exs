import Config

config :socketything, SocketythingWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}],
  check_origin: false,
  code_reloader: false,
  debug_errors: true,
  secret_key_base: "HOiBgooQ1k7LzoWzziblx5wxRMuhkeVYgGbjjyacxUgfXKTpVC/cHPzeVqjecuem"

config :logger, :default_formatter, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
