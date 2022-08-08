import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :tubuyaita, Tubuyaita.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "tubuyaita_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tubuyaita, TubuyaitaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "hKwywaD9b1Ijdntc6UUcw9yGoQZGLLCcrZZpFmVL/35d6BWpXHQ8UX7xrgbgjIQl",
  server: false

# In test we don't send emails.
config :tubuyaita, Tubuyaita.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
