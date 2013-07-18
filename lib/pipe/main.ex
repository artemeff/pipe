defmodule Pipe.Main do
  use Application.Behaviour

  ##
  # Starts all applications
  # Users, Hub...
  ##
  def start(_type, _args) do
    Pipe.Hub.Supervisor.start_link
    Pipe.Users.Supervisor.start_link
  end

end
