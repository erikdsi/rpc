defmodule Rpc.Mock.HTTPClient do
  alias HTTPoison.Response

  def get("http://54.152.221.29/images/b737_5.jpg") do
    {:ok, %Response{status_code: 200, body: "binary stuff"}}
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