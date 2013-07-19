defmodule Pipe.Api.Handler do

  def init(_transport, req, []), do:
    { :ok, req, :undefined }

  def handle(req, state) do
    { :ok, req2} = :cowboy_req.reply(200, [], "Hello world!", req)
    { :ok, req2, state}
  end

  def terminate(_reason, _req, _state), do:
    :ok

end
