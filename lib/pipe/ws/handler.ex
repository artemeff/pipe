defmodule Pipe.Ws.Handler do

  @period 1000

  def init(_transport, request, _options, _active) do
    IO.puts " -- [ws]   ws init"

    { :ok, request, :test }
  end

  
  #def stream(data, request, state) do
  #  IO.puts " -- [ws]   stream ok: '#{data}'"
  #
  #  { :ok, request, state }
  #end

  def stream(data, request, state) do
    IO.puts " -- [ws]   stream re: '#{data}'"

    { :reply, "stream: #{data};#{state}", request, state }
  end


  #def info(message, request, state) do 
  #  IO.puts " -- [ws]   info ok: '#{message}'"
  #
  #  { :ok, request, state }
  #end

  def info(message, request, state) do 
    IO.puts " -- [ws]   info re: '#{message}'"

    { :reply, "message: #{message};#{state}", request, state }
  end


  def terminate(_request, _state) do
    IO.puts " -- [ws]   terminate"

    :ok
  end

end
