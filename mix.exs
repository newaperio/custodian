defmodule Custodian.Mixfile do
  use Mix.Project

  def project do
    [
      app: :custodian,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive],
      name: "Custodian",
      source_url: "https://github.com/newaperio/custodian",
      source_root: ".",
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Custodian.Application, []},
      extra_applications: [:appsignal, :logger, :runtime_tools, :con_cache]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:appsignal, "~> 1.0"},
      {:con_cache, "~> 0.12.1"},
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:dialyxir, "~> 0.5.1"},
      {:excoveralls, "~> 0.8", only: :test},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:inch_ex, "~> 0.5", only: [:dev, :test]},
      {:jose, "~> 1.8"},
      {:junit_formatter, "~> 2.0", only: [:test]},
      {:phoenix,
       github: "phoenixframework/phoenix", ref: "7af99b6", override: true},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:sobelow, "~> 0.3", only: [:dev, :test]},
      {:tentacat, github: "edgurgel/tentacat"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  # Configuration for ExDoc documentation generator
  defp docs do
    [
      main: "readme",
      extras: ["README.md": [title: "README"]]
    ]
  end
end
