use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :discovery_api, DiscoveryApiWeb.Endpoint,
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :prestige,
  base_url: "http://localhost:8080",
  log_level: :debug

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

config :mix_test_watch,
  clear: true

config :redix,
  host: "redis-dev.7vmz1p.0001.usw2.cache.amazonaws.com"

config :discovery_api,
  divo: "test/integration/docker-compose.yaml",
  divo_wait: [dwell: 1000, max_tries: 20],
  ldap_user: System.get_env("LDAP_USER"),
  ldap_pass: System.get_env("LDAP_PASSWORD")

config :paddle, Paddle,
  host: System.get_env("LDAP_HOST"),
  base: "dc=internal,dc=smartcolumbusos,dc=com",
  timeout: 3000,
  account_subdn: "cn=users,cn=accounts"
