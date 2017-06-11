defmodule Rpc.TaskHelpersTest do
  use ExUnit.Case
  alias Rpc.Tasks.Helpers

  test "get file name and extension" do
    assert Helpers.get_file_name("test.it.jpg") == ["test.it", "jpg"]
  end
  test "get mime type" do
    assert Helpers.mime_type("test.gif") == "image/gif"
  end
  test "get url" do
    assert Helpers.get_url("images/test.jpg") == "http://localhost:4001/images/test.jpg"
  end
end