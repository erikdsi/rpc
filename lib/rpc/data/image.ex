defmodule Rpc.Data.Image do
  alias Rpc.Data
  alias ConCache, as: Cache


  @db_col Application.get_env(:rpc, :db_col)

  def create_list(list) do
    Cache.put(:rpc, "image-list", list)
    Data.insert(@db_col, %{"_id" => "image-list", "images" => list})
  end

  def get_list do
    if Cache.get(:rpc, "image-list") do
      Cache.get(:rpc, "image-list")
    else
      list = Data.find(@db_col, "image-list")["images"]
      Cache.put(:rpc, "image-list", list)
      list
    end
  end
end