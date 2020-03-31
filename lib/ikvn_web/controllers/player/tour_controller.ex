defmodule IkvnWeb.Player.TourController do
  use IkvnWeb, :controller

  alias Ikvn.Game

  plug :put_layout, "player.html"
  plug :load_resource when action in [:show]

  def show(conn, _params) do
    tasks = Game.list_tasks(conn.assigns.tour, conn.assigns.participation)
    render(conn, "show.html", tasks: tasks)
  end

  defp load_resource(conn, _opts) do
    tour = Game.get_tour!(conn.params["id"])
    assign(conn, :tour, tour)
  end
end
