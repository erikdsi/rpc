defmodule Rpc.ImageControllerTest do
  use Rpc.Web.ConnCase
  alias Rpc.Data

  @list [%{"one" => "one.jpg"}, %{"two" => "two.jpg"}]

  setup do
    Data.Image.create_list(@list)
    on_exit fn ->
      Rpc.Data.clean(Application.get_env(:rpc, :db_col))
    end
  end

  test "GET /api/images", %{conn: conn} do
    conn = get conn, "/api/images"
    assert json_response(conn, 200) == %{"data" => [%{"one" => "one.jpg"}, %{"two" => "two.jpg"}]}
  end
end