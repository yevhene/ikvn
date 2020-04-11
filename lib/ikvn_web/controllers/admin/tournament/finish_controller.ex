defmodule IkvnWeb.Admin.Tournament.FinishController do
  use IkvnWeb, :controller
  alias Ikvn.Game

  def create(conn, _params) do
    tournament = conn.assigns.tournament

    case Game.finish_tournament(tournament) do
      {:ok, _tournament} ->
        conn
        |> put_flash(:info, gettext "Tournament finished")
      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:info, gettext "Can't finish tournament")
    end
    |> redirect(to: Routes.admin_tournament_path(conn, :show, tournament))
  end
end
