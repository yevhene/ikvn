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

  pipeline :can_create_tournament do
    plug IkvnWeb.Plug.CheckPermission, permission: :create_tournament
  end

  pipeline :tournament do
    plug IkvnWeb.Plug.LoadTournament
  end

  pipeline :admin do
    plug IkvnWeb.Plug.AuthorizeAdmin
  end

  scope "/", IkvnWeb do
    pipe_through [:browser, :guardian, :require_login, :identify]

    resources "/profile", ProfileController,
      only: [:show], singleton: true

    scope "/admin", Admin, as: :admin do
      pipe_through [:can_create_tournament]

      resources "/tournaments", TournamentController, only: [:new, :create]
    end

    scope "/admin", Admin, as: :admin do
      pipe_through [:tournament, :admin]

      resources "/tournaments", TournamentController, only: [
        :show, :edit, :update
      ] do
        resources "/staff", StaffController,
          only: [:index, :create, :delete]
      end
    end
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

    resources "/", TournamentController, only: [:index]

    scope "/" do
      pipe_through [:tournament]

      resources "/tournaments", TournamentController, only: [:show]
    end
  end

  scope "/auth", IkvnWeb do
    pipe_through [:browser, :guardian]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
