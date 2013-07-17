Code.require_file "../test_helper.exs", __DIR__

defmodule HubTest do
  use ExUnit.Case, async: true

  test ".get with user_id" do
    refute Hub.get :u411
  end

  test ".add with user_id" do
    Hub.add :u48
  end

  test ".add with user_id and session", do: assert(false)
  test ".add with user_id, session and pid", do: assert(false)

  test ".update with user_id and session", do: assert(false)
  test ".update with user_id and pid", do: assert(false)

  test ".delete with user_id", do: assert(false)

  #test ".client" do
  #  Hub.client
  #end

  test "connect" do
    Hub.send :connect
  end
end
