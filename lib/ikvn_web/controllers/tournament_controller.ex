defmodule IkvnWeb.TournamentController do
  use IkvnWeb, :controller
  alias Ikvn.Admin
  alias Ikvn.Game

  def index(conn, _params) do
    {active_tournaments, finished_tournaments} = Game.list_public_tournaments(
      Map.get(conn.assigns, :current_user)
    )
    |> Enum.split_with(&Game.tournament_is_active?/1)

    future_tournaments = Admin.list_future_tournaments(
      conn.assigns.current_user
    )

    render(conn, "index.html",
      active_tournaments: active_tournaments,
      finished_tournaments: finished_tournaments,
      future_tournaments: future_tournaments
    )
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
