defmodule IkvnWeb.Admin.StaffController do
  use IkvnWeb, :controller
  alias Ikvn.{Account, Admin, Game}
  alias Ikvn.Account.User
  alias IkvnWeb.Helpers

  plug :load_resource when action in [:delete]

  def index(conn, _params) do
    staff = Admin.list_staff(conn.assigns.tournament)
    render(conn, "index.html", staff: staff)
  end

  def create(conn, %{"staff" => %{"nickname" => nickname, "role" => role}}) do
    tournament = conn.assigns.tournament

    case create_staff(nickname, role, tournament) do
      {:ok, _participation} ->
        conn
        |> put_flash(:info, gettext("User successfully added to staff"))
        |> redirect(
          to:
            Routes.admin_tournament_staff_path(
              conn,
              :index,
              tournament
            )
        )

      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(
          to:
            Routes.admin_tournament_staff_path(
              conn,
              :index,
              tournament
            )
        )
    end
  end

  def delete(conn, _params) do
    tournament = conn.assigns.tournament

    case delete_staff(conn.assigns.staff, tournament) do
      {:ok, _staff} ->
        conn
        |> put_flash(:info, gettext("User successfully removed from staff"))
        |> redirect(
          to:
            Routes.admin_tournament_staff_path(
              conn,
              :index,
              tournament
            )
        )

      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(
          to:
            Routes.admin_tournament_staff_path(
              conn,
              :index,
              tournament
            )
        )
    end
  end

  defp load_resource(conn, _opts) do
    staff = Game.get_participation!(conn.params["id"])
    assign(conn, :staff, staff)
  end

  defp create_staff(nickname, role, tournament) do
    case Account.find_user(nickname) do
      %User{} = user ->
        case Game.create_participation(%{
               tournament_id: tournament.id,
               user_id: user.id,
               role: role
             }) do
          {:ok, _participation} = success ->
            success

          {:error, %Ecto.Changeset{} = changeset} ->
            {:error,
             gettext(
               "User can't be added to staff. Reason: %{reason}",
               reason: Helpers.Error.fetch_errors(changeset)
             )}
        end

      _ ->
        {:error,
         gettext(
           "User \"%{nickname}\" is not exist",
           nickname: nickname
         )}
    end
  end

  defp delete_staff(staff, tournament) do
    if staff.user_id == tournament.creator_id do
      {:error, gettext("Can't remove the creator from staff")}
    else
      case Admin.delete_participation(staff) do
        {:ok, _staff} = success ->
          success

        {:error, %Ecto.Changeset{}} ->
          {:error, gettext("User can't be removed from staff")}
      end
    end
  end
end
