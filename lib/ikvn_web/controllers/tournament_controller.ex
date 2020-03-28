defmodule IkvnWeb.TournamentController do
  use IkvnWeb, :controller

  alias Ikvn.Game

  def index(conn, _params) do
    tournaments = Game.list_public_tournaments()
    active_tournaments = Enum.filter(tournaments, &Game.is_active?/1)
    finished_tournaments = Enum.filter(tournaments, &Game.is_finished?/1)
    future_tournaments = Game.list_future_tournaments(conn.assigns.current_user)
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
