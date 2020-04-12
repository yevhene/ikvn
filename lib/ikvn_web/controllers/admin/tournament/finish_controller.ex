defmodule IkvnWeb.Admin.Tournament.FinishController do
  use IkvnWeb, :controller
  alias Ikvn.Admin

  def create(conn, _params) do
    tournament = conn.assigns.tournament

    case Admin.finish_tournament(tournament) do
      {:ok, _tournament} ->
        conn
        |> put_flash(:info, gettext "Tournament finished")
        |> redirect(to: Routes.admin_tournament_path(conn, :show, tournament))
      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:info, gettext "Can't finish tournament")
        |> redirect(to: Routes.admin_tournament_path(conn, :show, tournament))
    end
  end
end
