defmodule GimnasioApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :gimnasio_app,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["ejercicio1/lib", "ejercicio2/lib"]
  defp elixirc_paths(_), do: ["ejercicio1/lib", "ejercicio2/lib"]

  defp deps do
  [
    {:jason, "~> 1.4"}
  ]
end
end
