defmodule Pipe.Ws.Handler do

  @period 1000

  def init(_transport, req, _opts, _active) do
    IO.puts " -- from init:"
    #IO.inspect transport
    IO.inspect req
    #IO.inspect opts
    #IO.inspect active
    IO.puts " --"

    { :ok, req, 'test' }
  end

  def stream(data, req, state) do
    IO.puts "ping #{data} received"
  
    { :reply, "pong", req, state }
  end

  #def stream(data, req, state) do
  #  IO.puts " -- from stream:"
  #  IO.inspect data
  #  IO.inspect req
  #  IO.inspect state
  #  IO.puts " --"
#
  #  { :ok, req, state }
  #end

  def info(:refresh, req, _) do
    time_ref = :erlang.send_after @period, self(), :refresh
    date_time = :cowboy_clock.rfc1123
    IO.puts "clock refresh timeout: #{date_time}"
  
    { :reply, date_time, req, time_ref }
  end

  def info(info, req, state) do
    IO.puts " -- from info:"
    IO.inspect info
    IO.inspect req
    IO.inspect state
    IO.puts " --"

    { :ok, req, state }
  end

  def terminate(_request, _any) do
    #IO.puts " -- from terminate:"
    #IO.inspect req
    #IO.inspect time_ref
    #IO.puts " --"

    :ok
  end

end
