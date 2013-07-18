defmodule Pipe.Users do
  use Application.Behaviour

  def start(_type, _args), do:
    Pipe.Users.Supervisor.start_link

end
