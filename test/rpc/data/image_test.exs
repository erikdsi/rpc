defmodule Rpc.ImageTest do
  use ExUnit.Case
  alias Rpc.Data

  @list [%{"one" => "one.jpg"}, %{"two" => "two.jpg"}]

  setup_all do
    on_exit fn ->
      Data.clean(Application.get_env(:rpc, :db_col))
    end
  end

  setup do
    Data.clean(Application.get_env(:rpc, :db_col))
    :ok
  end

  test "create list" do
    expects = {:ok, %Mongo.InsertOneResult{inserted_id: "image-list"}}
    assert Data.Image.create_list(@list) == expects
  end

  test "get list" do
    Data.Image.create_list(@list)
    assert Data.Image.get_list() == @list
  end

end