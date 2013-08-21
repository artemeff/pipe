defmodule Pipe.Api.Handler do

  # TODO
  # https://github.com/extend/cowboy/blob/master/examples/echo_post/src/toppage_handler.erl

  def init(_transport, req, []) do
    { key, new_req } = :cowboy_req.header("x-th-auth", req, false)

    case key do
      "1" -> { :ok, new_req, true }
       _  -> { :ok, new_req, false }
    end
  end

  def handle(req, state) when state do
    { :ok, new_req } = :cowboy_req.reply(200, [], "Hello world!", req)
    { :ok, new_req, state}
  end

  def handle(req, state) when not state do
    { :ok, new_req } = :cowboy_req.reply(401, [], "Unauthorized", req)
    { :ok, new_req, state}
  end

  def terminate(_reason, _req, _state), do:
    :ok

end
