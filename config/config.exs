# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ikvn,
  ecto_repos: [Ikvn.Repo]

# Configures the endpoint
config :ikvn, IkvnWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lwGQlVwYCzcKHDvDIBvqwItz8zhbrreZvgWYKVM6KUvicy1Dk4kumMuXwSm5NRrY",
  render_errors: [view: IkvnWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ikvn.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "IRjcjGKn"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
