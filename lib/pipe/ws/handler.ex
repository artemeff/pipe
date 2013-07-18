defmodule Pipe.Ws.Handler do

  @period 1000

  def init(_transport, req, _ppts, _active) do
    IO.puts "bullet init"
    time_ref = :erlang.send_after @period, self(), :refresh

    { :ok, req, time_ref }
  end

  def stream(data, req, state) do
    IO.puts "stream received #{data}"

    { :ok, req, state }
  end

  def info(:refresh, req, _) do
    time_ref = :erlang.send_after @period, self(), :refresh
    date_time = :cowboy_clock.rfc1123
    IO.puts "clock refresh timeout: #{date_time}"

    { :reply, date_time, req, time_ref }
  end

  def info(info, req, state) do
    :io.format("info received ~p~n", [info])

    { :ok, req, state }
  end

  def terminate(_Req, time_ref) do
    :io.format("bullet terminate~n")
    :erlang.cancel_timer(time_ref)

    :ok
  end

end
