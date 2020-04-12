defmodule IkvnWeb.Judge.TaskController do
  use IkvnWeb, :controller
  alias Ikvn.{Game, Judge}

  plug :load_resource

  def show(conn, _params) do
    {not_judged_solution, judged_solutions} =
      conn.assigns.task
      |> Judge.list_solutions(conn.assigns.participation)
      |> Enum.split_with(&(Enum.empty?(&1.marks)))

    render(conn, "show.html",
      not_judged_solution: not_judged_solution,
      judged_solutions: judged_solutions
    )
  end

  defp load_resource(conn, _opts) do
    task = Game.get_task!(conn.params["id"])
    assign(conn, :task, task)
  end
end
