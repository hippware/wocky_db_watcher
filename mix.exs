defmodule WockyDbWatcher.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wocky_db_watcher,
      version: version(),
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
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
      env: []
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
      {:configparser_ex, "~> 4.0", only: [:dev, :test]},
      {:dawdle_db, "~> 0.5"},
      {:distillery, "~> 2.0", runtime: false},
      {:rexbug, ">= 1.0.0"}
    ]
  end
end
