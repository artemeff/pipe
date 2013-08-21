defmodule Pipe.Ws.Main do

  def init(_transport, req, []), do:
    { :ok, req, :undefined }

  def handle(req, state) do
    { :ok, new_req } = :cowboy_req.reply(200, [], body, req)
    { :ok, new_req , state}
  end

  def terminate(_reason, _req, _state), do:
    :ok

  ##

  defp body do
    { :ok, content } = File.read("priv/index.html")
    
    content
  end

end
