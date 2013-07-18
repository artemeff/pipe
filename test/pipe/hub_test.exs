Code.require_file "../test_helper.exs", __DIR__

defmodule HubTest do
  use Amrita.Sweet, async: true

  it "test" do
    :gen_server.call(:hub, :test) |> contains "test"
  end

end
