defmodule Rpc.DataTest do
  use ExUnit.Case
  alias Rpc.Data

  setup_all do
    on_exit fn ->
      Data.clean("test")
    end
  end

  test "insert" do
    document = %{_id: "test-id", obj: %{a: 1}}
    assert Data.insert("test", document) == {:ok, %Mongo.InsertOneResult{inserted_id: "test-id"}}
  end

  test "find" do
    Data.insert("test", %{_id: "find-id", obj: %{a: 1}})
    assert Data.find("test", "find-id") == %{"_id" => "find-id", "obj" => %{"a" => 1}}
  end

  test "delete" do
    Data.insert("test", %{_id: "delete-id", obj: %{a: 1}})
    assert Data.delete("test", "delete-id") == {:ok, %{"_id" => "delete-id", "obj" => %{"a" => 1}}}
  end

end