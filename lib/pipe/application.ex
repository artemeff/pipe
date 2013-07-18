defmodule Pipe.Application do
  use Application.Behaviour

  ##
  # Starts all applications
  # Users, Hub...
  ##
  def start(_type, _args) do
    # cowboy router
    dispatch = :cowboy_router.compile [
      {:_, [
        {'/ws', Pipe.Ws.WsHandler, []},
        {'/', Pipe.Ws.ClientHandler, []}
      ]}
    ]

    # start cowboy handler
    :cowboy.start_http :ws, 100,
      [{:port, 8080}],
      [{:env, [{:dispatch, dispatch}]}]

    # start other applications
    Pipe.Hub.Supervisor.start_link
    Pipe.Users.Supervisor.start_link
  end

  ##
  # Stops all applications
  ##
  def stop(_state), do: :ok

end
