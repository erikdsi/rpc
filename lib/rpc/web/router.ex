defmodule Rpc.Web.Router do
  use Rpc.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Rpc.Web do
    pipe_through :api
    get "/images", ImageController, :index
  end
end
