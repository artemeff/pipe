defmodule Pipe.Users.Supervisor do
  use Supervisor.Behaviour

  # A convenience to start the supervisor
  def start_link(), do:
    :supervisor.start_link(__MODULE__, [])

  # The callback invoked when the supervisor starts
  def init(_args) do
    process = [ worker(Pipe.Users.Server, []) ]

    supervise process, strategy: :one_for_one
  end

end
