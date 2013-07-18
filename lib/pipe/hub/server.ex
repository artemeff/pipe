defmodule Pipe.Hub.Server do
  use GenServer.Behaviour

  ##
  # OTP methods
  ##

  def start_link(user_list), do:
    :gen_server.start_link({ :local, :hub }, __MODULE__, user_list, [])

  def init(user_list), do:
    { :ok, user_list }

  @doc """
  test
  """
  def handle_call(:test, _from, user_list), do:
    { :reply, "test", user_list }

end
