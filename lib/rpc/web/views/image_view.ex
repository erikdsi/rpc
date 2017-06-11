defmodule Rpc.Web.ImageView do
  use Rpc.Web, :view

  def render("list.json", %{list: list}) do
    %{data: list}
  end

end