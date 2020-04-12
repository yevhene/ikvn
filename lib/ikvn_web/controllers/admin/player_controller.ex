defmodule IkvnWeb.Admin.PlayerController do
  use IkvnWeb, :controller
  alias Ikvn.{Admin, Game}

  plug :load_resource when action in [:delete]

  def index(conn, _params) do
    players = Admin.list_players(conn.assigns.tournament)
    render(conn, "index.html", players: players)
  end

  def delete(conn, _params) do
    case Admin.delete_participation(conn.assigns.staff) do
      {:ok, _staff} ->
        conn
        |> put_flash(:info, gettext(
          "Player successfully removed from tournament"
        ))
        |> redirect(to: Routes.admin_tournament_player_path(
          conn, :index, conn.assigns.tournament)
        )
      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:error, gettext("Player can't be removed from tournament"))
        |> redirect(to: Routes.admin_tournament_player_path(
          conn, :index, conn.assigns.tournament)
        )
    end

  end

  defp load_resource(conn, _opts) do
    staff = Game.get_participation!(conn.params["id"])
    assign(conn, :staff, staff)
  end
end
