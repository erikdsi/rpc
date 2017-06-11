defmodule Rpc.Mock.Img do
  def open(_) do
    :ok
  end
  def resize(_,_) do
    :ok
  end
  def save(_,_) do
    :ok
  end
end