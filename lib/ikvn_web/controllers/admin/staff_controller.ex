defmodule IkvnWeb.Admin.StaffController do
  use IkvnWeb, :controller

  import Ikvn.Utils.Validation

  alias Ikvn.Game

  plug :load_resource when action in [:delete]
  plug :put_layout, "admin.html"

  def index(conn, _params) do
    staff = Game.list_participations(conn.assigns.tournament, [:admin, :judge])
    render(conn, "index.html", staff: staff)
  end

  def create(conn, %{"staff" => %{"nickname" => nickname, "role" => role}}) do
    tournament = conn.assigns.tournament

    case Game.create_staff(nickname, role, tournament) do
      {:ok, _participation} ->
        conn
        |> put_flash(:info, gettext "User successfully added to staff")
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, gettext(
          "User can't be added to staff. Reason: %{reason}",
          reason: fetch_errors(changeset)
        ))
      {:error, error} ->
        conn
        |> put_flash(:error, error)
    end
    |> redirect(to:
      Routes.admin_tournament_staff_path(conn, :index, tournament)
    )
  end

  def delete(conn, _params) do
    case Game.delete_participation(conn.assigns.staff) do
      {:ok, _staff} ->
        conn
        |> put_flash(:info, gettext "User successfully deleted from staff")
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, gettext(
          "User can't be removed from staff. Reason: %{reason}",
          reason: fetch_errors(changeset)
        ))
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
