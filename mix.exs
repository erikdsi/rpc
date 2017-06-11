defmodule Rpc.Mixfile do
  use Mix.Project

  def project do
    [app: :rpc,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Rpc.Application, []},
     extra_applications: [:con_cache, :logger, :runtime_tools, :poolboy, :mongodb, :httpoison]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3.0-rc"},
     {:phoenix_pubsub, "~> 1.0"},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:poolboy, ">= 0.0.0"},
     {:poison, "~> 3.0"},
     {:mogrify, "~> 0.5.4"},
     {:sweet_xml, "~> 0.6.5"},
     {:httpoison, "~> 0.11.1"},
     {:hackney, "~> 1.8.5", override: true},
     {:ex_aws, "~> 1.0"},
     {:con_cache, "~> 0.12.0"},
     {:mongodb, ">= 0.0.0"}]
  end
end
