defmodule Pipe.Mixfile do
  use Mix.Project

  def project do
    [ app: :pipe,
      version: "0.0.1",
      deps: deps(Mix.env) ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [:kernel, :stdlib, :cowboy, :gproc],
      registered: [],
      mod: { Pipe.Application, [] }
    ]
  end

  # Returns the list of dependencies
  defp deps(:prod) do
    [
      { :exredis, "0.0.4",  [ github: "artemeff/exredis", tag: "v0.0.4" ] },
      { :json,    "0.0.1",  [ github: "artemeff/json", branch: "upgrade-version" ] },
      { :bullet,  "0.4.1",  [ github: "extend/bullet", ref: "45888" ] },
      { :erlzmq,            [ github: "zeromq/erlzmq2", ref: "be811" ] },
      { :gproc,   "0.2.17", [ github: "uwiger/gproc", tag: "0.2.17" ] }
    ]
  end

  defp deps(_) do
    deps(:prod) ++
      [
        { :amrita,  "0.2.2", [ github: "josephwilk/amrita", tag: "v0.2.2" ]}
      ]
  end
end
