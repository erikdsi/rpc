defmodule Rpc.Tasks.Consume do
  alias HTTPoison.Response
  alias Rpc.Data.Image

  require Logger

  @ws "http://54.152.221.29/images.json"
  @out Application.app_dir(:rpc, Application.get_env(:rpc, :img_dir))
  @tmp Application.app_dir(:rpc, Application.get_env(:rpc, :tmp_dir))
  @use_aws Application.get_env(:rpc, :use_aws)
  @bucket Application.get_env(:rpc, :bucket)
  @region Application.get_env(:ex_aws, :region)

  @http Application.get_env(:rpc, :http_client)
  @aws Application.get_env(:rpc, :aws_client)

  def generate_image_list do
    IO.puts "Consuming web service..."
    list = get_image_list()
    IO.puts "Resizing Images..."
    File.mkdir_p(@out)
    File.mkdir_p(@tmp)
    list = Enum.map(list, fn(el) -> resize_image(el) end)
    IO.puts "Populating db..."
    Image.create_list(list)
    IO.puts "Done"
  end

  def get_image_name(image) do
    image
    |> String.split("/")
    |> Enum.reverse
    |> Enum.at(0)
    |> String.split(".")
  end

  def save_resized(image, to, size_str) do
    image
    |> Mogrify.resize(size_str)
    |> Mogrify.save(path: to)
  end

  def mime_type(file_name) do
    file_name = String.downcase(file_name)
    cond do
      String.ends_with?(file_name, ["jpg", "jpeg"]) -> "image/jpeg"
      String.ends_with?(file_name, ["png"]) -> "image/png"
      String.ends_with?(file_name, ["gif"]) -> "image/gif"
    end
  end

  def local_url(file_name) do
    host = Application.get_env(:rpc, Rpc.Web.Endpoint)[:url][:host]
    port = case Mix.env do
      :dev -> Application.get_env(:rpc, Rpc.Web.Endpoint)[:http][:port]
      :test -> Application.get_env(:rpc, Rpc.Web.Endpoint)[:http][:port]
      :prod -> ""
    end
    protocol = if Application.get_env(:rpc, Rpc.Web.Endpoint)[:url][:port] == 443 do
      "https"
    else
      "http"
    end
    port = if is_integer(port) do ":#{port}" else "" end
    "#{protocol}://#{host}#{port}/images/#{file_name}"
  end

  def put_aws(file_name) do
    path = "images/#{file_name}"
    content = File.open!("#{@out}/#{file_name}") |> IO.binread(:all)
    url = "https://s3-#{@region}.amazonaws.com/#{@bucket}/#{path}"
    req = @aws.S3.put_object(@bucket, path, content, content_type: mime_type(file_name), acl: :public_read)
    with {:ok, _} <- @aws.request(req) do
      url
    else
      error -> Logger.debug(inspect(error))
    end
  end

  def resize_image(url) do
    [name, ext] = get_image_name(url)
    fname = name
    original = "#{@tmp}/#{fname}.#{ext}"
    small = "#{fname}_sm.#{ext}"
    medium = "#{fname}_md.#{ext}"
    large = "#{fname}_lg.#{ext}"
    with {:ok, %Response{status_code: 200, body: payload}} <- @http.get(url),
         {:ok, og} <- File.open(original, [:write]),
         :ok <- IO.binwrite(og, payload) do
      image = Mogrify.open(original)
      save_resized(image, "#{@out}/#{small}", "320x240")
      save_resized(image, "#{@out}/#{medium}", "384x288")
      save_resized(image, "#{@out}/#{large}", "640x480")
      File.rm(original)
      if @use_aws do
        %{small: put_aws(small), medium: put_aws(medium), large: put_aws(large)}
      else
        %{small: local_url(small), medium: local_url(medium), large: local_url(large)}
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