defmodule Rpc.Mock.File do
  def mkdir_p(_) do
    :ok
  end
  def open(_, _) do
    {:ok, "pid"}
  end
  def open(_) do
    {:ok, "pid"}
  end
  def open!(_) do
    "pid"
  end
  def rm(_) do
    "rm"
  end
end