defmodule Pipe.Ws.Main do

  def init(_transport, req, []), do:
    { :ok, req, :undefined }

  def handle(req, state) do
    { :ok, req2} = :cowboy_req.reply(200, [], body, req)
    { :ok, req2, state}
  end

  def terminate(_reason, _req, _state), do:
    :ok

  ##

  defp body do
    { :ok, content } = File.read("priv/index.html")
    
    content
  end

end
