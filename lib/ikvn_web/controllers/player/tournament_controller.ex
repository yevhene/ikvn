defmodule IkvnWeb.Player.TournamentController do
  use IkvnWeb, :controller

  plug :put_layout, "player.html"

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
