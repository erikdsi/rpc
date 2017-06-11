use Mix.Config

config :ex_aws,
  region: "sa-east-1"

config :rpc,
  http_client: Rpc.Mock.HTTPClient,
  aws_client: Rpc.Mock.Aws,
  bucket: "erik-b2w",
  img_dir: "priv/test/static/images",
  tmp_dir: "priv/test/tmp",
  use_aws: true,
  db_col: "image_list"

config :rpc, :db,
  name: "rpc_test"
# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rpc, Rpc.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
