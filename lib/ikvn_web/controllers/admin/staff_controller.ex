defmodule IkvnWeb.Admin.StaffController do
  use IkvnWeb, :controller
  alias Ikvn.Account
  alias Ikvn.Account.User
  alias Ikvn.Admin
  alias Ikvn.Game
  alias IkvnWeb.Helpers

  plug :load_resource when action in [:delete]

  def index(conn, _params) do
    staff = Admin.list_staff(conn.assigns.tournament)
    render(conn, "index.html", staff: staff)
  end

  def create(conn, %{"staff" => %{"nickname" => nickname, "role" => role}}) do
    tournament = conn.assigns.tournament

    case Account.find_user(nickname) do
      %User{} = user ->
        case Game.create_participation(%{
          tournament_id: tournament.id,
          user_id: user.id,
          role: role
        }) do
          {:ok, _participation} ->
            conn
            |> put_flash(:info, gettext "User successfully added to staff")
          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:error, gettext(
              "User can't be added to staff. Reason: %{reason}",
              reason: Helpers.Error.fetch_errors(changeset)
            ))
        end
      _ ->
        conn
        |> put_flash(:error, gettext(
          "User \"%{nickname}\" is not exist", nickname: nickname
        ))
    end
    |> redirect(to:
      Routes.admin_tournament_staff_path(conn, :index, tournament)
    )
  end

  def delete(conn, _params) do
    if conn.assigns.tournament.creator_id == conn.assigns.staff.user_id do
      conn
      |> put_flash(:error, gettext("Can't remove the creator from staff"))
    else
      case Admin.delete_participation(conn.assigns.staff) do
        {:ok, _staff} ->
          conn
          |> put_flash(:info, gettext("User successfully removed from staff"))
        {:error, %Ecto.Changeset{}} ->
          conn
          |> put_flash(:error, gettext("User can't be removed from staff"))
      end
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
