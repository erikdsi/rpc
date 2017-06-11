defmodule Rpc.Mock.IO do
  def binread(_,_) do
    "binary stuff"
  end
  def binwrite(_,_) do
    :ok
  end
end