defmodule Rpc.Tasks.Helpers do

  def get_file_name(file_name) do
    name_ext = file_name
    |> String.split("/")
    |> Enum.reverse
    |> Enum.at(0)
    |> String.split(".")
    if length(name_ext) > 2 do
      [ext | pieces] = Enum.reverse(name_ext)
      name = pieces
      |> Enum.reverse
      |> Enum.reduce(fn(el, acc) -> acc <> "." <> el end)
      [name, ext]
    else
      name_ext
    end
  end

  def mime_type(file_name) do
    file_name = String.downcase(file_name)
    cond do
      String.ends_with?(file_name, ["jpg", "jpeg"]) -> "image/jpeg"
      String.ends_with?(file_name, ["png"]) -> "image/png"
      String.ends_with?(file_name, ["gif"]) -> "image/gif"
    end
  end

  def get_url(path) do
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
    "#{protocol}://#{host}#{port}/#{path}"
  end

end