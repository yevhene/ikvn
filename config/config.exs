# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

get_env = fn (name) ->
  System.get_env(name) || raise "environment variable #{name} is missing"
end

config :ikvn,
  ecto_repos: [Ikvn.Repo]

# Configures the endpoint
config :ikvn, IkvnWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: get_env.("SECRET_KEY_BASE"),
  render_errors: [view: IkvnWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ikvn.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "IRjcjGKn"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    facebook: {Ueberauth.Strategy.Facebook, []}
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: get_env.("FACEBOOK_CLIENT_ID"),
  client_secret: get_env.("FACEBOOK_CLIENT_SECRET")

config :ikvn, IkvnWeb.Guardian,
  issuer: "Ikvn.#{Mix.env}",
  secret_key: get_env.("GUARDIAN_SECRET_KEY")

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :oauth2,
  serializers: %{
    "application/json" => Jason
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
