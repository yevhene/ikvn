defmodule IkvnWeb.Judge.TaskController do
  use IkvnWeb, :controller
  alias Ikvn.Judge

  plug :load, resources: [:tour, :task]

  def show(conn, _params) do
    {not_judged_solution, judged_solutions} =
      conn.assigns.task
      |> Judge.list_solutions(conn.assigns.participation)
      |> Enum.split_with(&Enum.empty?(&1.marks))

    render(conn, "show.html",
      not_judged_solution: not_judged_solution,
      judged_solutions: judged_solutions
    )
  end
end
