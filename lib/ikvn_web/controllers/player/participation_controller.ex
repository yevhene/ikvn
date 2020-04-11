defmodule IkvnWeb.Player.ParticipationController do
  use IkvnWeb, :controller
  alias Ikvn.Game

  def create(conn, _params) do
    tournament = conn.assigns.tournament
    if Game.tournament_is_finished?(tournament) do
      conn
      |> put_flash(:error, gettext "Tournament is finished")
      |> redirect(to: Routes.tournament_path(conn, :index))
    else
      case Game.create_participation(participation_params(conn)) do
        {:ok, _participation} ->
          conn
          |> put_flash(:info, gettext "You participate now")
          |> redirect(to:
            Routes.player_tournament_tour_path(conn, :index, tournament)
          )
        {:error, _} ->
          conn
          |> put_flash(:error, gettext "Participation failed. Contact Admin")
          |> redirect(to: Routes.tournament_path(conn, :index))
      end
    end
  end

  defp participation_params(conn) do
    %{
      "user_id" => conn.assigns.current_user.id,
      "tournament_id" => conn.assigns.tournament.id
    }
  end
end
