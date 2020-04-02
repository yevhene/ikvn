defmodule IkvnWeb.Judge.TourController do
  use IkvnWeb, :controller

  alias Ikvn.Game

  def show(conn, _params) do
    tasks = Game.list_tasks(conn.assigns.tour, conn.assigns.participation)
    render(conn, "show.html", tasks: tasks)
  end
end
