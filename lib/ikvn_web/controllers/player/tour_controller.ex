defmodule IkvnWeb.Player.TourController do
  use IkvnWeb, :controller

  alias Ikvn.Game

  plug :put_layout, "player.html"
  plug :load_resource when action in [:show]

  def index(conn, _params) do
    tours = Game.list_tours(conn.assigns.tournament)
    render(conn, "index.html", tours: tours)
  end

  def show(conn, _params) do
    tasks = Game.list_tasks(conn.assigns.tour)
    render(conn, "show.html", tasks: tasks)
  end

  defp load_resource(conn, _opts) do
    tour = Game.get_tour!(conn.params["id"])
    assign(conn, :tour, tour)
  end
end
