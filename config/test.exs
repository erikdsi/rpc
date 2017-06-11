use Mix.Config

config :ex_aws,
  region: "sa-east-1"

config :rpc,
  http_client: Rpc.Mock.HTTPClient,
  aws_client: Rpc.Mock.Aws,
  fs_client: Rpc.Mock.File,
  io_client: Rpc.Mock.IO,
  img_client: Rpc.Mock.Img

config :rpc, :db,
  database: "rpc_test"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rpc, Rpc.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
