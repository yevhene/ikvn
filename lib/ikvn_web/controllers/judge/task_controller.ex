defmodule IkvnWeb.Judge.TaskController do
  use IkvnWeb, :controller

  alias Ikvn.Game

  plug :load_resource

  def show(conn, _params) do
    solutions = Game.list_solutions(
      conn.assigns.task, conn.assigns.participation
    )
    render(conn, "show.html", solutions: solutions)
  end

  defp load_resource(conn, _opts) do
    task = Game.get_task!(conn.params["id"])
    assign(conn, :task, task)
  end
end
