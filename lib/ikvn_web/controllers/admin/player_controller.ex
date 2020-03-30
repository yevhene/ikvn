defmodule IkvnWeb.Admin.PlayerController do
  use IkvnWeb, :controller

  alias Ikvn.Game

  plug :put_layout, "admin.html"

  def index(conn, _params) do
    players = Game.list_participations(conn.assigns.tournament, [:player])
    render(conn, "index.html", players: players)
  end
end
