defmodule Pipe.Api.Handler do

  def init(_transport, req, []), do:
    { :ok, req, :undefined }

  def handle(req, state) do
    { :ok, new_request } = :cowboy_req.reply(200, [], "Hello world!", req)
    { :ok, new_request, state}
  end

  def terminate(_reason, _req, _state), do:
    :ok

end
