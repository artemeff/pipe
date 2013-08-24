defmodule Pipe.Users.Server do
  use Exredis
  use GenServer.Behaviour

  ##
  # OTP methods
  ##

  def start_link(), do:
    :gen_server.start_link({ :local, :users }, __MODULE__, start, [])

  def init(redis), do:
    { :ok, redis }

  @doc """
  
  """
  def handle_cast({:notify, user_id, message}, _from, redis), do:
    { :reply, notify(user_id, message), redis }

  @doc """
  
  """
  def handle_call({:subscribe, user_id}, _from, redis), do:
    { :reply, subscribe(user_id), redis }

  @doc """

  """
  def handle_call({:unsubscribe, user_id}, _from, redis), do:
    { :reply, unsubscribe(user_id), redis }

  @doc """
  Get user PID by user id

  :gen_server.call(:users, {:pid, 123})
  """
  def handle_call({:pid, user_id}, _from, redis), do:
    { :reply, pid(redis, user_id), redis }

  @doc """
  Get user_id by session, for auth
  
  :gen_server.call(:users, {:session, "session_id"})
  """
  def handle_call({:session, session_id}, _from, redis), do:
    { :reply, session(redis, session_id), redis }

  @doc """
  Get all users sessions by his id
  
  :gen_server.call(:users, {:sessions, 123})
  """
  def handle_call({:sessions, id}, _from, redis), do:
    { :reply, sessions(redis, id), redis }

  @doc """
  Get online state by user_id
  
  :gen_server.call(:users, {:online, 123})
  :gen_server.call(:users, {:online, 123, state})
  """
  def handle_call({:online, id}, _from, redis), do:
    { :reply, online(redis, id), redis }

  def handle_call({:online, id, state}, _from, redis), do:
    { :reply, online(redis, id, state), redis }

  ##
  # Main methods for getting data from Redis storage
  ##

  # subscribe user
  defp subscribe(user_id) when is_integer(user_id), do:
    :gproc.reg({ :p, :l, { :users_hub, user_id }})

  # unsubscribe user
  defp unsubscribe(user_id) when is_integer(user_id), do:
    :gproc.unreg({ :p, :l, { :users_hub, user_id }})

  # notify user
  defp notify(user_id, message) when is_integer(user_id) and is_binary(message), do:
    :gproc.send({ :p, :l, user_id}, message)

  # get PID by user id
  defp pid(redis, user_id) when is_pid(redis) and is_integer(user_id), do:
    redis |> query(["GET", "pids:#{user_id}"]) |> prepare_pid

  # gets false or user id by session id
  defp session(redis, session_id) when is_pid(redis) and is_binary(session_id), do:
    redis |> query(["GET", "session:#{session_id}"]) |> prepare_auth

  # get all sessions by user id
  defp sessions(redis, id) when is_pid(redis) and is_integer(id), do:
    redis |> query(["SMEMBERS", "sessions:#{id}"])

  # get true if user is online or false
  defp online(redis, id) when is_pid(redis) and is_integer(id), do:
    redis |> query(["GET", "online:#{id}"]) |> any_to_boolean

  # set user online state by his id
  defp online(redis, id, state) when is_pid(redis) and is_integer(id) and is_boolean(state), do:
    redis |> query(["SET", "online:#{id}", (state |> boolean_to_integer)])

  ##
  # Helpers
  ##

  defp prepare_pid(:undefined), do: "start"
  defp prepare_pid(value), do: value |> any_to_pid

  defp prepare_auth(:undefined), do: false
  defp prepare_auth(value) when is_binary(value), do: value |> binary_to_integer

  defp any_to_pid(value) when is_binary(value), do:
    "#{value}" |> binary_to_list |> list_to_pid

  defp boolean_to_integer(true),  do: 1
  defp boolean_to_integer(false), do: 0

  defp any_to_boolean(:undefined), do: false
  defp any_to_boolean(value), do: value != "0"

end
