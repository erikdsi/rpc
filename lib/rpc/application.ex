defmodule Rpc.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(Rpc.Web.Endpoint, []),
      supervisor(ConCache, [[], [name: :rpc]]),
      # Start your own worker by calling: Rpc.Worker.start_link(arg1, arg2, arg3)
      # worker(Rpc.Worker, [arg1, arg2, arg3]),
      worker(Mongo, [[name: :mongo, database: Application.get_env(:rpc, :db)[:name], pool: DBConnection.Poolboy]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rpc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
