import Config

config :socketything, SocketythingWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "pLMcxGdd1MiuJfHtO0uzXdNCIYcwerBLjWTv4vV/M+eshwT9vomzNeaX3TOhmjHT",
  server: false

config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime
