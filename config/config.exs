# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :stores,
  ecto_repos: [Stores.Repo]

# Configures the endpoint
config :stores, StoresWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "L9/rsH+zBmM+8sPUpZfFNhslHDeJvmLullhdH8OP9uk3lngVD+pGdqRMSw+5PxA5",
  render_errors: [view: StoresWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Stores.PubSub,
  live_view: [signing_salt: "NspUtUOq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
