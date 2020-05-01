defmodule IkvnWeb.AuthPlugs do
  use Phoenix.Router
  import Plug.Conn
  import Guardian.Plug, only: [current_resource: 1]
  import IkvnWeb.{Gettext, Permissions}
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import IkvnWeb.Helpers.Error, only: [error_response: 2]
  alias IkvnWeb.Router.Helpers, as: Routes

  pipeline :can_open_dashboard do
    plug :check_permission, to: :open_dashboard
  end

  pipeline :authenticate do
    plug Guardian.Plug.EnsureAuthenticated
  end

  def current_user(conn, _opts) do
    current_user = current_resource(conn)
    assign(conn, :current_user, current_user)
  end

  def identify(conn, _opts) do
    current_user = conn.assigns.current_user

    if current_user && !current_user.nickname do
      conn
      |> put_flash(:info, gettext("Please fill your profile"))
      |> redirect(to: Routes.profile_path(conn, :edit))
      |> halt()
    else
      conn
    end
  end

  def check_permission(conn, opts) do
    if can?(conn.assigns.current_user, opts[:to]) do
      conn
    else
      conn |> error_response(:forbidden)
    end
  end
end
