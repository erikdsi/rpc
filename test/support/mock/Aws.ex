defmodule Rpc.Mock.Aws do

  defmodule S3 do
    def put_object(_, _, _, _) do
      %{}
    end
  end
  def request(_) do
    {:ok, :nope}
  end
end