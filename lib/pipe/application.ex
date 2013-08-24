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
        {'/', Pipe.Ws.Main, []},
        {'/ws', :bullet_handler, [{:handler, Pipe.Ws.Handler}]},
        {'/static/[...]', :cowboy_static, [
          {:directory, {:priv_dir, :pipe, []}},
          {:mimetypes, [
            {".js", ["application/javascript"]}
          ]}
        ]}
      ]}
    ]

    # start cowboy handler
    :cowboy.start_http :http, 100,
      [{:port, 8080}],
      [{:env, [{:dispatch, dispatch}]}]

    # start other applications
    Pipe.Api.Supervisor.start_link("tcp://127.0.0.1:1234")
    Pipe.Hub.Supervisor.start_link
    Pipe.Users.Supervisor.start_link
  end

  ##
  # Stops all applications
  ##
  def stop(_state), do: :ok

end
