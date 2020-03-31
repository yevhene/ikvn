defmodule IkvnWeb.Player.TournamentController do
  use IkvnWeb, :controller

  alias Ikvn.Game

  plug :put_layout, "player.html"

  def show(conn, _params) do
    tours = Game.list_tours(conn.assigns.tournament)
    render(conn, "show.html", tours: tours)
  end
end
