defmodule Rpc.Web.ImageController do
  use Rpc.Web, :controller

  alias Rpc.Data.Image

  def index(conn, _params) do
    list = Image.get_list()
    render(conn, "list.json", list: list)
  end
end