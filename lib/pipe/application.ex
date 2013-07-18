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
        {'/ws',    :bullet_handler, [:handler, Pipe.Ws.Handler]},
        {'/[...]', :cowboy_static, [
          {:directory, {:priv_dir, :bullet, []}},
          {:mimetypes, [
            {".js", ["application/javascript"]}
          ]}
        ]}
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
