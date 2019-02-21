defmodule WockyDbWatcher.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wocky_db_watcher,
      version: version(),
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      elvis_config: [%{src_dirs: [], rules: []}],
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp version do
    {ver_result, _} = System.cmd("elixir", ["version.exs"])
    ver_result
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {WockyDBWatcher.Application, []},
      env: [
        wocky_env: {:system, "WOCKY_ENV", "dev"},
        wocky_inst: {:system, "WOCKY_INST", "local"},
        wocky_host: {:system, "WOCKY_HOST", "localhost"}
      ]
    ]
  end

  defp aliases do
    [
      recompile: ["clean", "compile"],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.0"},
      {:ex_aws_sqs, "~> 2.0"},
      {:hackney, "~> 1.7"},
      {:sweet_xml, "~> 0.6"},
      {:postgrex, "~> 0.14.0"},
      {:confex, "~> 3.3"},
      {:poison, "~> 3.0 or ~> 4.0"},
      {:rexbug, ">= 1.0.0"},

      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:distillery, "~> 2.0", runtime: false}
    ]
  end
end
