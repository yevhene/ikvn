defmodule IkvnWeb.Player.TourController do
  use IkvnWeb, :controller
  alias Ikvn.Game
  alias Ikvn.Player

  def index(conn, _params) do
    tours = Game.list_tours(conn.assigns.tournament)
    render(conn, "index.html", tours: tours)
  end

  def show(conn, _params) do
    tasks = Player.list_tasks(conn.assigns.tour, conn.assigns.participation)
    render(conn, "show.html", tasks: tasks)
  end
end
