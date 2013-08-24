defmodule Pipe.Api.Supervisor do
  use Supervisor.Behaviour

  # A convenience to start the supervisor
  def start_link(addr), do:
    :supervisor.start_link(__MODULE__, [addr])

  # The callback invoked when the supervisor starts
  def init([addr]) do
    process = [ worker(Pipe.Api.Server, [addr]) ]

    supervise process, strategy: :one_for_one
  end

end
