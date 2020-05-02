defmodule IkvnWeb.Router do
  use IkvnWeb, :router
  import Phoenix.LiveDashboard.Router
  import IkvnWeb.AuthPlugs
  import IkvnWeb.GamePlugs
  import IkvnWeb.UserTime, only: [browser_timezone: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery

    plug :put_secure_browser_headers, %{
      "Content-Security-Policy" =>
        Application.get_env(:ikvn, :content_security_policy)
    }

    plug :browser_timezone, default: "Europe/Kiev"

    plug Phoenix.LiveDashboard.RequestLogger,
      param_key: "request_logger",
      cookie_key: "request_logger"
  end

  pipeline :guardian do
    plug Ueberauth

    plug Guardian.Plug.Pipeline,
      module: IkvnWeb.Guardian,
      error_handler: IkvnWeb.Guardian.ErrorHandler

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug :current_user
  end

  # Live dashboard
  scope "/" do
    pipe_through [:browser, :guardian, :can_open_dashboard]

    live_dashboard "/dashboard", metrics: IkvnWeb.Telemetry
  end

  # Private pages
  scope "/", IkvnWeb do
    pipe_through [:browser, :guardian, :authenticate, :identify]

    resources "/profile", ProfileController, only: [:show], singleton: true

    # Not yet an admin
    scope "/admin", Admin, as: :admin do
      pipe_through :can_create_tournament

      resources "/tournaments", TournamentController, only: [:new, :create]
    end

    # Tournament admin
    scope "/admin", Admin, as: :admin do
      pipe_through :admin

      resources "/tournaments", TournamentController,
        only: [:show, :edit, :update, :delete] do
        resources "/finish", Tournament.FinishController, only: [:create]

        resources "/staff", StaffController, only: [:index, :create, :delete]

        resources "/players", PlayerController, only: [:index, :delete]

        resources "/tours", TourController do
          resources "/tasks", TaskController, except: [:index, :show]
        end
      end
    end

    # Tournament judge
    scope "/judge", Judge, as: :judge do
      pipe_through :judge

      scope "/tournaments/:tournament_id", as: :tournament do
        resources "/tours", TourController, only: [:index, :show] do
          resources "/tasks", TaskController, only: [:show] do
            scope "/solutions/:solution_id", as: :solution do
              resources "/marks", MarkController,
                only: [:create],
                singleton: true
            end
          end
        end
      end
    end

    # Not yet a player
    scope "/player", Player, as: :player do
      scope "/tournaments/:tournament_id", as: :tournament do
        resources "/participation", ParticipationController,
          only: [:create],
          singleton: true
      end
    end

    # Tournament player
    scope "/player", Player, as: :player do
      pipe_through :player

      scope "/tournaments/:tournament_id", as: :tournament do
        resources "/tours", TourController, only: [:index, :show] do
          scope "/tasks/:task_id", as: :task do
            resources "/solution", SolutionController,
              only: [:new, :create, :edit, :update],
              singleton: true
          end
        end
      end
    end
  end

  # Pages for authenticated but not identified user
  scope "/", IkvnWeb do
    pipe_through [:browser, :guardian, :authenticate]

    resources "/session", SessionController, only: [:delete], singleton: true

    resources "/profile", ProfileController,
      only: [:edit, :update],
      singleton: true
  end

  # Public pages
  scope "/", IkvnWeb do
    pipe_through [:browser, :guardian, :identify]

    resources "/", TournamentController, only: [:index]

    resources "/tournaments", TournamentController, only: [:show] do
      scope "/", Tournament do
        resources "/results", ResultController, only: [:show], singleton: true

        resources "/digest", DigestController, only: [:show], singleton: true
      end
    end
  end

  # Static public pages
  scope "/", IkvnWeb do
    pipe_through [:browser]

    get "/terms", PageController, :terms
  end

  # Oauth authentication
  scope "/auth", IkvnWeb do
    pipe_through [:browser, :guardian]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
