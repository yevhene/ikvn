defmodule IkvnWeb.Admin.StaffController do
  use IkvnWeb, :controller

  alias Ikvn.Game

  plug :load_resource when action in [:delete]
  plug :put_layout, "admin.html"

  def index(conn, _params) do
    staff = Game.list_staff(conn.assigns.tournament)
    render(conn, "index.html", staff: staff)
  end

  def create(conn, %{"staff" => %{"nickname" => nickname, "role" => role}}) do
    tournament = conn.assigns.tournament
    current_user = conn.assigns.current_user

    case Game.create_staff(nickname, role, tournament, current_user) do
      {:ok, _participation} ->
        conn
        |> put_flash(:info, gettext "User successfully added to staff")
        |> redirect(to:
          Routes.admin_tournament_staff_path(conn, :index, tournament)
        )
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to:
          Routes.admin_tournament_staff_path(conn, :index, tournament)
        )
    end
  end

  def delete(conn, _params) do
    case Game.delete_participation(conn.assigns.staff) do
      {:ok, _staff} ->
        conn
        |> put_flash(:info, gettext "User successfully deleted from staff")
      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error,
          gettext "User can't be deleted from staff. Contact Admin"
        )
      {:error, error} ->
        conn
        |> put_flash(:error, error)
    end
    |> redirect(to:
      Routes.admin_tournament_staff_path(conn, :index, conn.assigns.tournament)
    )
  end

  defp load_resource(conn, _opts) do
    staff = Game.get_participation!(conn.params["id"])
    assign(conn, :staff, staff)
  end
end
