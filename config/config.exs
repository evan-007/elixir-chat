# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :plm_live,
  namespace: PLMLive,
  ecto_repos: [PLMLive.Repo]

# Configures the endpoint
config :plm_live, PLMLiveWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VzFcdoy8O1YH2/6M9MUG0w149yk4ZyWcOVz6hx+fgGH/cwtwg72USOtFDqHIjzqW",
  render_errors: [view: PLMLiveWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PLMLive.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
