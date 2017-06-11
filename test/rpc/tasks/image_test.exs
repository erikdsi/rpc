defmodule Rpc.ImageTaskTest do
  use ExUnit.Case
  alias Rpc.Tasks.Image

  @bucket Application.get_env(:rpc, :bucket)
  @region Application.get_env(:ex_aws, :region)
  @use_aws Application.get_env(:rpc, :use_aws)

  setup_all do
    on_exit fn ->
      Rpc.Data.clean(Application.get_env(:rpc, :db_col))
    end
  end

  setup do
    Rpc.Data.clean(Application.get_env(:rpc, :db_col))
    :ok
  end

  test "upload to s3" do
    assert Image.put_aws("images/b737_5_md.jpg") == "https://s3-#{@region}.amazonaws.com/#{@bucket}/images/b737_5_md.jpg"
  end

  test "get list of images" do
    assert Image.get_image_list() == ["http://54.152.221.29/images/b737_5.jpg"]
  end

  test "resize image" do
    expects = if @use_aws do
      %{large: "https://s3-#{@region}.amazonaws.com/#{@bucket}/images/b737_5_lg.jpg",
        medium: "https://s3-#{@region}.amazonaws.com/#{@bucket}/images/b737_5_md.jpg",
        small: "https://s3-#{@region}.amazonaws.com/#{@bucket}/images/b737_5_sm.jpg"}
    else
      %{large: "http://localhost:4001/images/b737_5_lg.jpg",
        medium: "http://localhost:4001/images/b737_5_md.jpg",
        small: "http://localhost:4001/images/b737_5_sm.jpg"}
    end
    assert Image.resize_image("http://54.152.221.29/images/b737_5.jpg") == expects
  end
end