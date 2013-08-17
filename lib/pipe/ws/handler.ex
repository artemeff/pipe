defmodule Pipe.Ws.Handler do
  @moduledoc """
  
  State is:

    `[:active, :user_session, :user_id]`

  Where `:active` is

    * `true`  - WebSocket connection
    * `:once` - Polling connection

  """

  ##
  # Connect to ws server
  #
  # :ok       - all fine, just work
  # :shutdown - close connection in websockets and
  #   try to reconnect in polling
  ##

  def init(_transport, request, _options, active) do
    # define state
    state = { active, nil, nil }

    # get token
    { token, _ } = :cowboy_req.cookie("_token", request)

    # auth user
    case :gen_server.call(:users, { :session, token }) do
      user_id when is_integer(user_id) ->
        # set new state
        new_state = state |> set_elem(1, token) |> set_elem(2, user_id)

        # subscribe user
        :gproc.reg({ :p, :l, user_id })

        # send ok new_state
        # { :ok, request, new_state }

      false ->
        # falsy
        # { :shutdown, request, :unathorized }
        false

    end

    { :ok, request, state }
    #{ :shutdown, request, :ok }
  end

  ##
  # Receive -> send message, it method touch by user data,
  # eg when anybody sends message to our ws/polling server
  # it method runs
  #
  # :ok    - just say to client that request is delivered
  # :reply - request is delivered and sand message with response
  ##

  def stream(data, request, state) do
    # get data from state
    { active, user_session, user_id } = state

    :gproc.send({ :p, :l, user_id }, "sess: #{user_session}")

    #{ :ok, request, state }
    { :reply, "notify: #{rand}", request, state }
  end

  ##
  # Send message by server, it method should touch by server
  # and its send any data to client
  #
  # :ok    - just say to client that request is delivered
  # :reply - request is delivered and sand message with response
  ##

  def info(message, request, state) do 
    #IO.write " -- [ws]   info re: '#{message}'"

    #{ :ok, request, state }
    { :reply, "message: #{message}", request, state }
  end

  ##
  # Shutdown connect
  #
  # :ok
  ##

  def terminate(_request, _state) do
    #IO.write " -- [ws]   terminate with state: "
    #IO.inspect state

    :ok
  end

end
