defmodule Blog.Dataloader.MixProject do
  use Mix.Project

  def project do
    [
      app: :blog_dataloader,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Blog.Dataloader.Application, []}
    ]
  end

  defp elixirc_paths(:prod), do: ["lib"]
  defp elixirc_paths(:dev), do: ["priv/repo/seeds" | elixirc_paths(:prod)]
  defp elixirc_paths(:test), do: ["test/support" | elixirc_paths(:dev)]

  defp deps do
    [
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:dataloader, "~> 1.0.0"},
      {:ecto_sql, "~> 3.0"},
      {:jason, "~> 1.0"},
      {:plug, "~> 1.8"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      # Development
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.3", only: [:dev, :test]}
    ]
  end
end
