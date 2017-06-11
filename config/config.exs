# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :rpc,
  static_dir: "priv/static",
  tmp_dir: "priv/tmp",
  bucket: "erik-bucket",
  use_aws: true,
  db_col: "image_list"

config :rpc, :db,
  name: :mongo,
  pool: DBConnection.Poolboy
#AWS
config :ex_aws,
  access_key_id: [System.get_env("AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_env("AWS_SECRET_ACCESS_KEY"), :instance_role],
  region: "sa-east-1"

# Configures the endpoint
config :rpc, Rpc.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JKta6GukYavA/EzR4JiFSFJxsiUCCLy2l/RDNJXTYy8A0CWVBfKWxLgY9YWITMEJ",
  render_errors: [view: Rpc.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Rpc.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
