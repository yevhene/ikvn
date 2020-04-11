defmodule IkvnWeb.Plug.LoadTournament do
  import Plug.Conn
  import IkvnWeb.Helpers.Error, only: [error_response: 2]
  alias Ikvn.Game

  def init(opts), do: opts

  def call(conn, _opts) do
    user = conn.assigns.current_user
    tournament = Game.get_tournament(tournament_id(conn))
    participation = Game.get_user_participation(user, tournament)

    if Game.tournament_is_available?(tournament, participation) do
      conn
      |> assign(:tournament, tournament)
      |> assign(:participation, participation)
    else
      conn
      |> error_response(:not_found)
      |> halt
    end
  end

  defp tournament_id(conn) do
    conn.params["tournament_id"] || conn.params["id"]
  end
end
