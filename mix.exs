defmodule DiscoveryApi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :discovery_api,
      compilers: [:phoenix, :gettext | Mix.compilers()],
      version: "0.11.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_paths: test_paths(Mix.env()),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      mod: {DiscoveryApi.Application, []},
      extra_applications: [:logger, :runtime_tools, :corsica, :prestige]
    ]
  end

  defp deps do
    [
      {:paddle, "~> 0.1"},
      {:cachex, "~> 3.0"},
      {:corsica, "~> 1.0"},
      {:cowboy, "~> 2.6"},
      {:csv, "~> 2.3"},
      {:credo, "~> 1.1", only: [:dev, :test, :integration], runtime: false},
      {:checkov, "~> 0.4", only: [:test, :integration]},
      {:divo, "~> 1.1"},
      {:ex_json_schema, "~> 0.6", only: [:test, :integration]},
      {:guardian, "~> 1.2"},
      {:gettext, "~> 0.11"},
      {:httpoison, "~> 1.5"},
      {:faker, "~> 0.12"},
      {:jason, "~> 1.1"},
      {:mix_test_watch, "~> 0.9", only: :dev, runtime: false},
      {:patiently, "~> 0.2"},
      {:phoenix, "~> 1.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:placebo, "~> 1.2", only: [:dev, :test]},
      {:plug_cowboy, "~> 2.1"},
      {:prestige, "~> 0.3"},
      {:prometheus_plugs, "~> 1.1"},
      {:prometheus_phoenix, "~>1.2"},
      {:quantum, "~>2.3"},
      {:redix, "~> 0.10"},
      {:streaming_metrics, "~> 2.1"},
      {:smart_city_registry, "~> 3.3"},
      {:smart_city_test, "~> 0.3", only: [:test, :integration]},
      {:temporary_env, "~> 2.0", only: :test, runtime: false},
      {:timex, "~>3.0"},
      {:sobelow, "~> 0.8"},
      {:husky, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5.1", only: :dev, runtime: false},
      # updating version breaks
      {:distillery, "2.0.14"},
      # distillery breaks @ 2.1.0 due to elixir 1.9 support
      {:poison, "3.1.0"}
      # poison breaks @ 4.0.1 due to encode_to_iotdata missing from 4.0
    ]
  end

  defp test_paths(:integration), do: ["test/integration", "test/utils"]
  defp test_paths(_), do: ["test/unit", "test/utils"]

  defp elixirc_paths(:test), do: ["test/utils", "lib"]
  defp elixirc_paths(:integration), do: ["test/utils", "lib"]
  defp elixirc_paths(_), do: ["lib"]
end
