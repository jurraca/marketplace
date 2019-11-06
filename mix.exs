defmodule Marketplace.MixProject do
  use Mix.Project

  def project do
    [
      app: :marketplace,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger], 
      included_applications: [:ex_syslogger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
	 {:ex_syslogger, github: "slashmili/ex_syslogger", tag: "1.4.0"},
   {:poison, "~> 3.1"}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
