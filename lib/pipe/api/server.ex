defmodule Pipe.Api.Server do
  use GenServer.Behaviour

  defrecord State, addr: nil, context: nil, socket: nil, error: nil

  ##
  # OTP methods
  ##

  def start_link(addr), do:
    :gen_server.start_link({ :local, :api }, __MODULE__, State.new(addr: addr), [])

  def init(state) do
    case connect(:context, state) do
      { :ok, new_state } ->
        # spawn looper
        spawn(__MODULE__, :handle, [:ok, new_state])

        # return state
        { :ok, new_state }

      { :error, new_state } ->
        { :terminate, new_state }

      _ ->
        { :terminate, state }
    end
  end

  ##
  # Helper methods
  ##

  def handle(:ok, state) do
    case :erlzmq.recv(state.socket) do
      { :ok, message } ->
        # change it!
        user_id = -1
        
        # serve
        :gen_server.call(:users, { :notify, user_id, message })

        # loop
        handle(:ok, state)

      { :error, _type } ->
        # try to reconnect
        connect(:context, State.new(addr: state.addr))

      any ->
        { :error, state.update(error: { :api_handle, any }) }
    end
  end

  # TODO
  def handle(:error, state) do
    { :error, state }
  end

  ##
  # Internal functions
  ##

  defp connect(:context, state) do
    case :erlzmq.context do
      { :ok, context } ->
        connect(:socket, state.update(context: context))

      { :error, type } ->
        { :error, state.update(error: type) }

      any ->
        { :error, state.update(error: { :api_context, any }) }

    end
  end

  defp connect(:socket, state) do
    case :erlzmq.socket(state.context, :pull) do
      { :ok, socket } ->
        connect(:bind, state.update(socket: socket))

      { :error, type } ->
        { :error, state.update(error: type) }

      any ->
        { :error, state.update(error: { :api_socket, any }) }

    end
  end

  defp connect(:bind, state) do
    case :erlzmq.bind(state.socket, state.addr) do
      :ok ->
        { :ok, state }

      { :error, type } ->
        { :error, state.update(error: type) }

      any ->
        { :error, state.update(error: { :api_bind, any }) }

    end
  end

  defp connect(_, state) do
    { :error, state.update(error: :api_any) }
  end

end
