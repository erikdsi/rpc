defmodule Rpc.ConsumeTest do
  use ExUnit.Case
  alias Rpc.Tasks.Consume

  @images Application.get_env(:rpc, :img_dir)
  @tmp Application.get_env(:rpc, :tmp_dir)
  @bucket Application.get_env(:rpc, :bucket)
  @region Application.get_env(:ex_aws, :region)

  setup_all do
    on_exit fn ->
      Rpc.Data.clean(Application.get_env(:rpc, :db_col))
      File.rm_rf(Application.app_dir(:rpc, "priv/test/static"))
      File.rm_rf(@tmp)
    end
  end
  setup do
    Rpc.Data.clean(Application.get_env(:rpc, :db_col))
    :ok
  end

  test "upload to s3" do
    Consume.generate_image_list()
    assert Consume.put_aws("b737_5_md.jpg") == "https://s3-#{@region}.amazonaws.com/#{@bucket}/images/b737_5_md.jpg"
  end

  test "get image name" do
    assert Consume.get_image_name("http://54.152.221.29/images/b737_5.jpg") == ["b737_5", "jpg"]
  end

  test "get list of images" do
    assert Consume.get_image_list() == ["http://54.152.221.29/images/b737_5.jpg"]
  end

  test "resize image" do
    expects = %{large: "https://s3-#{@region}.amazonaws.com/#{@bucket}/images/b737_5_lg.jpg",
              medium: "https://s3-#{@region}.amazonaws.com/#{@bucket}/images/b737_5_md.jpg",
              small: "https://s3-#{@region}.amazonaws.com/#{@bucket}/images/b737_5_sm.jpg"}
    assert Consume.resize_image("http://54.152.221.29/images/b737_5.jpg") == expects
  end
end