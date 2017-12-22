# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :custodian,
  ecto_repos: [Custodian.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :custodian, CustodianWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "U+h+/jvWMWv75E6m8bBoK+kv43/WWSdwP/IRcW0ZY5IsadWiOs3NOBYCBaG/Ab7m",
  render_errors: [view: CustodianWeb.ErrorView, accepts: ~w(json)]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Tentacat with bot headers
config :tentacat, :extra_headers, [{"Accept", "application/vnd.github.machine-man-preview+json"}]

# Configures app's GitHub API client
config :custodian, :github_api, Custodian.Github.Tentacat

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
