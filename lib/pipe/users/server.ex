defmodule Pipe.Users.Server do
  @moduledoc """
  High-level bindings for users in Redis storage
  Uses OTP conviction
  """

  use Exredis
  use GenServer.Behaviour

  ##
  # OTP methods
  ##

  def start_link(redis), do:
    :gen_server.start_link({ :local, :users }, __MODULE__, redis, [])

  def init(redis), do:
    { :ok, redis }

  @doc """
  Get user PID by user session

  :gen_server.call(:users, {:pid, "session"})
  """
  def handle_call({:pid, session}, _from, redis), do:
    { :reply, pid(redis, session), redis }

  @doc """
  Get all users sessions by his id
  
  :gen_server.call(:users, {:sessions, 123})
  """
  def handle_call({:sessions, id}, _from, redis), do:
    { :reply, sessions(redis, id), redis }

  @doc """
  Get all users sessions by his id
  
  :gen_server.call(:users, {:online, 123})
  :gen_server.call(:users, {:online, 123, state})
  """
  def handle_call({:online, id}, _from, redis), do:
    { :reply, online(redis, id), redis }

  def handle_call({:online, id, state}, _from, redis), do:
    { :reply, online(redis, id, state), redis }

  # def handle_cast({ :push, new }, redis) do
  #   { :noreply, [new|redis] }
  # end

  ##
  # Helper methods for getting data from Redis storage
  ##

  defp pid(redis, session) when is_pid(redis) and is_binary(session) do
    id = redis |> query(["GET", "pids:#{session}"])

    unless id == :undefined do
      pid = any_to_pid id
    else
      # spawn fuckin' process for user
      pid = nil
    end

    pid
  end

  defp sessions(redis, id) when is_pid(redis) and is_integer(id), do:
    redis |> query(["SMEMBERS", "sessions:#{id}"])

  defp online(redis, id) when is_pid(redis) and is_integer(id), do:
    redis |> query(["GET", "online:#{id}"]) |> any_to_boolean

  defp online(redis, id, state) when is_pid(redis) and is_integer(id) and is_boolean(state), do:
    redis |> query(["SET", "online:#{id}", state])

  defp any_to_pid(value) when is_binary(value), do:
    "<#{value}>" |> binary_to_list |> list_to_pid

  defp any_to_boolean(value) when is_binary(value), do: value == "true"

  defp any_to_boolean(:undefined), do: false

end
