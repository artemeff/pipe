defmodule Pipe.Hub do
  @moduledoc """
  Module for spawning and storing
  processes for each user
  """
  
  use Exredis

  @doc """
  Get user by session
  """
  def get(session) when is_binary(session), do:
    start |> query ["GET", session]

end
