defmodule IkvnWeb.Router do
  use IkvnWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :guardian do
    plug Ueberauth
    plug Guardian.Plug.Pipeline,
      module: IkvnWeb.Guardian,
      error_handler: IkvnWeb.Guardian.ErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug IkvnWeb.Plug.CurrentUser
  end

  pipeline :identify do
    plug IkvnWeb.Plug.IdentifyCurrentUser
  end

  pipeline :require_login do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", IkvnWeb do
    pipe_through [:browser, :guardian, :require_login, :identify]

    resources "/profile", ProfileController,
      only: [:show], singleton: true
  end

  scope "/", IkvnWeb do
    pipe_through [:browser, :guardian, :require_login]

    resources "/session", SessionController,
      only: [:delete], singleton: true
    resources "/profile", ProfileController,
      only: [:edit, :update], singleton: true
  end

  scope "/", IkvnWeb do
    pipe_through [:browser, :guardian, :identify]

    get "/", PageController, :index
  end

  scope "/auth", IkvnWeb do
    pipe_through [:browser, :guardian]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
