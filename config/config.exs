# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sponsorly,
  ecto_repos: [Sponsorly.Repo]

# Configures the endpoint
config :sponsorly, SponsorlyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jWf+zrcckDMoV7ZnGpabUocPDZeeMfah4CpQGdgF/3huWqJHcNBOigHzvaQaedIQ",
  render_errors: [view: SponsorlyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Sponsorly.PubSub,
  live_view: [signing_salt: "9rIMPUq8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Bamboo configuration
config :sponsorly, SponsorlyWeb.Mailer,
  adapter: Bamboo.LocalAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
