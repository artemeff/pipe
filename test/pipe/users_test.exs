Code.require_file "../test_helper.exs", __DIR__

defmodule UsersTest do
  use Amrita.Sweet, async: true
  use Exredis

  # clear all redis keys
  setup_all do
    client = start

    client |> query ["FLUSHALL"]

    stop client
  end

  fact "subscribe" do
    :gen_server.call(:users, {:subscribe, 8841}) |> equals true

    :gen_server.cast(:users, {:notify, 8841, "test"}) |> equals :ok

    :gen_server.call(:users, {:unsubscribe, 8841}) |> equals true
  end

  fact "online methods should work" do
    # set state to redis
    :gen_server.call(:users, {:online, 8841, true}) |> contains "OK"

    # check state
    :gen_server.call(:users, {:online, 8841}) |> truthy

    # start redis
    redis = start

    # it should be "1"
    redis |> query(["GET", "online:8841"]) |> contains "1"

    # set it to false
    :gen_server.call(:users, {:online, 8841, false}) |> contains "OK"

    # it should be "0"
    redis |> query(["GET", "online:8841"]) |> contains "0"

    # stop redis server
    redis |> stop
  end

  fact "sessions methods should work" do
    # it should be empty
    :gen_server.call(:users, {:sessions, 8841}) |> equals []

    # start redis
    redis = start

    # add session
    redis |> query(["SADD", "sessions:8841", "test123"]) |> contains "1"
    redis |> query(["SADD", "sessions:8841", "test456"]) |> contains "1"

    # check it now
    :gen_server.call(:users, {:sessions, 8841}) |> equals ["test456", "test123"]

    # stop
    redis |> stop
  end

  fact "session method should work" do
    # it should be empty
    :gen_server.call(:users, {:session, "testSeSSion"}) |> equals false

    # start redis
    redis = start

    # add session
    redis |> query(["SET", "session:testSeSSion", "123"]) |> contains "OK"

    # check it now
    :gen_server.call(:users, {:session, "testSeSSion"}) |> equals 123

    # stop
    redis |> stop
  end

  it "pid method should work" do
    # set state to redis
    :gen_server.call(:users, {:pid, 8841}) |> contains "start"

    # check it in redis
    redis = Exredis.start

    # it should be "1"
    redis |> query(["SET", "pids:8841", "<0.1.1>"]) |> contains "OK"

    # it should be "0"
    :gen_server.call(:users, {:pid, 8841}) |> pid_to_list |> equals '<0.1.1>'

    # stop redis server
    redis |> Exredis.stop
  end

end
