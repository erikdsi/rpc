defmodule Rpc.Tasks.Image do
  alias HTTPoison.Response
  alias Rpc.Data
  alias Rpc.Tasks.Helpers

  require Logger

  @ws "http://54.152.221.29/images.json"
  @static Application.app_dir(:rpc, Application.get_env(:rpc, :static_dir))
  @tmp Application.app_dir(:rpc, Application.get_env(:rpc, :tmp_dir))
  @use_aws Application.get_env(:rpc, :use_aws)
  @bucket Application.get_env(:rpc, :bucket)
  @region Application.get_env(:ex_aws, :region)

  @http Application.get_env(:rpc, :http_client)
  @aws Application.get_env(:rpc, :aws_client)
  @fs Application.get_env(:rpc, :fs_client)
  @io Application.get_env(:rpc, :io_client)
  @img Application.get_env(:rpc, :img_client)

  def generate_image_list do
    IO.puts "Setting up..."
    @fs.mkdir_p("#{@static}/images")
    @fs.mkdir_p(@tmp)
    IO.puts "Consuming webservice..."
    list = get_image_list()
    IO.puts "Generating images..."
    list = Enum.map(list, fn(el) -> resize_image(el) end)
    IO.puts "Saving to db..."
    list = Data.Image.create_list(list)
    IO.puts "Done!"
    list
  end

  def save_resized(image, to, size_str) do
    image
    |> @img.resize(size_str)
    |> @img.save(path: to)
  end

  def put_aws(path) do
    content = @fs.open!("#{@static}/#{path}") |> @io.binread(:all)
    url = "https://s3-#{@region}.amazonaws.com/#{@bucket}/#{path}"
    req = @aws.S3.put_object(@bucket, path, content, content_type: Helpers.mime_type(path), acl: :public_read)
    with {:ok, %{status_code: 200}} <- @aws.request(req) do
      url
    else
      error -> Logger.debug(inspect(error))
    end
  end

  def resize_image(url) do
    [fname, ext] = Helpers.get_file_name(url)
    original = "#{@tmp}/#{fname}.#{ext}"
    small = "images/#{fname}_sm.#{ext}"
    medium = "images/#{fname}_md.#{ext}"
    large = "images/#{fname}_lg.#{ext}"
    with {:ok, %Response{status_code: 200, body: payload}} <- @http.get(url),
         {:ok, og} <- @fs.open(original, [:write]),
         :ok <- @io.binwrite(og, payload) do
      image = @img.open(original)
      save_resized(image, "#{@static}/#{small}", "320x240")
      save_resized(image, "#{@static}/#{medium}", "384x288")
      save_resized(image, "#{@static}/#{large}", "640x480")
      @fs.rm(original)
      if @use_aws do
        %{small: put_aws(small), medium: put_aws(medium), large: put_aws(large)}
      else
        %{small: Helpers.get_url(small), medium: Helpers.get_url(medium), large: Helpers.get_url(large)}
      end

    else
      error -> Logger.debug(inspect(error))
    end
  end

  def get_image_list do
    with {:ok, %Response{status_code: 200, body: payload}} <- @http.get(@ws),
         {:ok, decoded} <- Poison.decode(payload) do
      Enum.map(decoded["images"], fn(el) ->
        el["url"]
      end)
    else
      error -> Logger.debug(inspect(error))
    end
  end
end