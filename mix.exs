defmodule Pipe.Mixfile do
  use Mix.Project

  def project do
    [ app: :pipe,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies
  defp deps do
    [
      { :exredis, "0.0.2", [ github: "artemeff/exredis" ] },
      { :json,    "0.0.1", [ github: "artemeff/json" ] },
      { :socket,  "0.1.2", [ github: "meh/elixir-socket" ] }
    ]
  end
end
