defmodule Pipe.Ws.Handler do
  @moduledoc """
  
  State is:

    `[:active, :session, :id]`

  Where `:active` is

    * `true`  - WebSocket connection
    * `:once` - Polling connection

  """

  defrecord State, active: nil, session: nil, id: nil

  @doc """
  Connect to ws server
  
  :ok       - all fine, just work
  :shutdown - close connection in websockets and try to reconnect in polling
  """
  def init(_transport, request, _options, active) do
    # define state
    state = State.new(active: active)

    # get token
    { token, _ } = :cowboy_req.cookie("_token", request)

    # auth user
    case :gen_server.call(:users, { :session, token }) do
      user_id when is_integer(user_id) ->
        # set new state
        new_state = state.update(session: token, id: user_id)

        # subscribe user
        :gproc.reg({ :p, :l, user_id })

        # send ok new_state
        { :ok, request, new_state }

      false ->
        # falsy
        { :shutdown, request, :unathorized }

    end

    #{ :ok, request, state }
    #{ :shutdown, request, :ok } 
  end

  @doc """
  Receive -> send message, it method touch by user data,
  eg when anybody sends message to our ws/polling server
  it method runs
  
  :ok    - just say to client that request is delivered
  :reply - request is delivered and send message with response
  """
  def stream(_data, request, state) do
    # send `wha?` message
    :gproc.send({ :p, :l, state.id }, "sess: #{state.session}")

    #{ :ok, request, state }
    { :reply, "notify", request, state }
  end

  @doc """
  Send message by server, it method should touch by server
  and its send any data to client
  
  :ok    - just say to client that request is delivered
  :reply - request is delivered and sand message with response
  """
  def info(message, request, state) do 
    #IO.write " -- [ws]   info re: '#{message}'"

    #{ :ok, request, state }
    { :reply, "message: #{message}", request, state }
  end

  @doc """
  Shutdown connect
  
  :ok
  """
  def terminate(_request, _state), do:
    :ok

end
