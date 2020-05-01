defmodule IkvnWeb.Router do
  use IkvnWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery

    plug :put_secure_browser_headers, %{
      "Content-Security-Policy" => """
        default-src 'none'; \
        script-src 'self' 'unsafe-eval' 'unsafe-inline'; \
        connect-src 'self'; \
        frame-src 'self'; \
        font-src 'self' data:; \
        img-src * data:; \
        style-src 'self' 'unsafe-inline'; \
      """
    }

    plug IkvnWeb.Plug.BrowserTimezone, default: "Europe/Kiev"
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

  pipeline :can_open_dashboard do
    plug IkvnWeb.Plug.CheckPermission, permission: :open_dashboard
  end

  pipeline :request_logger do
    plug Phoenix.LiveDashboard.RequestLogger,
      param_key: "request_logger",
      cookie_key: "request_logger"
  end

  pipeline :can_submit_solution do
    plug IkvnWeb.Plug.CheckCanSubmitSolution
  end

  pipeline :can_submit_mark do
    plug IkvnWeb.Plug.CheckCanSubmitMark
  end

  pipeline :tournament do
    plug IkvnWeb.Plug.LoadTournament
  end

  pipeline :tour do
    plug IkvnWeb.Plug.LoadTour
  end

  pipeline :admin do
    plug IkvnWeb.Plug.AuthorizeRole, role: :admin
    plug :put_layout, {IkvnWeb.LayoutView, "admin.html"}
  end

  pipeline :judge do
    plug IkvnWeb.Plug.AuthorizeRole,
      role: :judge,
      accessible_by: [:admin, :judge]

    plug :put_layout, {IkvnWeb.LayoutView, "judge.html"}
  end

  pipeline :player do
    plug IkvnWeb.Plug.AuthorizeRole, role: :player
    plug :put_layout, {IkvnWeb.LayoutView, "player.html"}
  end

  # Live dashboard
  scope "/" do
    pipe_through [:browser, :guardian, :can_open_dashboard, :request_logger]

    live_dashboard "/dashboard", metrics: IkvnWeb.Telemetry
  end

  # Private pages
  scope "/", IkvnWeb do
    pipe_through [:browser, :guardian, :require_login, :identify]

    resources "/profile", ProfileController, only: [:show], singleton: true

    # Not yet an admin
    scope "/admin", Admin, as: :admin do
      pipe_through [:can_create_tournament]

      resources "/tournaments", TournamentController, only: [:new, :create]
    end

    # Tournament admin
    scope "/admin", Admin, as: :admin do
      pipe_through [:tournament, :admin]

      resources "/tournaments", TournamentController,
        only: [
          :show,
          :edit,
          :update,
          :delete
        ] do
        resources "/finish", Tournament.FinishController, only: [:create]

        resources "/staff", StaffController, only: [:index, :create, :delete]

        resources "/players", PlayerController, only: [:index, :delete]

        resources "/tours", TourController do
          scope "/" do
            pipe_through [:tour]

            resources "/tasks", TaskController, except: [:index, :show]
          end
        end
      end
    end

    # Tournament judge
    scope "/judge", Judge, as: :judge do
      pipe_through [:tournament, :judge]

      scope "/tournaments/:tournament_id", as: :tournament do
        resources "/tours", TourController, only: [:index]

        scope "/" do
          pipe_through [:tour]

          resources "/tours", TourController, only: [:show] do
            resources "/tasks", TaskController, only: [:show] do
              scope "/solutions/:solution_id", as: :solution do
                pipe_through [:can_submit_mark]

                resources "/marks", MarkController,
                  only: [:create],
                  singleton: true
              end
            end
          end
        end
      end
    end

    # Not yet a player
    scope "/player", Player, as: :player do
      pipe_through [:tournament]

      scope "/tournaments/:tournament_id", as: :tournament do
        resources "/participation", ParticipationController,
          only: [:create],
          singleton: true
      end
    end

    # Tournament player
    scope "/player", Player, as: :player do
      pipe_through [:tournament, :player]

      scope "/tournaments/:tournament_id", as: :tournament do
        resources "/tours", TourController, only: [:index]

        scope "/" do
          pipe_through [:tour]

          resources "/tours", TourController, only: [:show] do
            scope "/tasks/:task_id", as: :task do
              pipe_through [:can_submit_solution]

              resources "/solution", SolutionController,
                only: [:new, :create, :edit, :update],
                singleton: true
            end
          end
        end
      end
    end
  end

  # Pages for authenticated but not identified user
  scope "/", IkvnWeb do
    pipe_through [:browser, :guardian, :require_login]

    resources "/session", SessionController, only: [:delete], singleton: true

    resources "/profile", ProfileController,
      only: [:edit, :update],
      singleton: true
  end

  # Public pages
  scope "/", IkvnWeb do
    pipe_through [:browser, :guardian, :identify]

    resources "/", TournamentController, only: [:index]

    scope "/" do
      pipe_through [:tournament]

      resources "/tournaments", TournamentController, only: [:show]

      scope "/tournaments/:tournament_id", Tournament, as: :tournament do
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
