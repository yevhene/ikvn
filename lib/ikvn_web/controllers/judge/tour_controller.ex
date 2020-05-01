defmodule IkvnWeb.Judge.TourController do
  use IkvnWeb, :controller
  alias Ikvn.{Game, Judge}

  plug :load_tour when action in [:show]

  def index(conn, _params) do
    tours = Game.list_tours(conn.assigns.tournament)
    render(conn, "index.html", tours: tours)
  end

  def show(conn, _params) do
    tasks = Judge.list_tasks(conn.assigns.tour, conn.assigns.participation)
    render(conn, "show.html", tasks: tasks)
  end
end
