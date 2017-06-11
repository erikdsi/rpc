defmodule Rpc.Mock.HTTPClient do
  alias HTTPoison.Response

  def get("http://54.152.221.29/images/b737_5.jpg") do
    img = File.open!(Application.app_dir(:rpc, "priv/test/sample/plane.jpg"))
    |> IO.binread(:all)
    {:ok, %Response{status_code: 200, body: img}}
  end
  def get("http://54.152.221.29/images.json") do
    body = """
    {
      "images": [
        {
          "url": "http://54.152.221.29/images/b737_5.jpg"
        }
      ]
    }
    """
    {:ok, %Response{status_code: 200, body: body}}
  end
end