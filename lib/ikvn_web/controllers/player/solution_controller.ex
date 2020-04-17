defmodule IkvnWeb.Player.SolutionController do
  use IkvnWeb, :controller
  alias Ikvn.{Game, Player}
  alias Ikvn.Game.Solution

  plug :load_parent_resource
  plug :load_resource when action in [:edit, :update]

  def new(conn, _params) do
    changeset = Player.change_solution(%Solution{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"solution" => params}) do
    tournament = conn.assigns.tournament
    tour = conn.assigns.tour

    case Player.create_solution(solution_params(conn, params)) do
      {:ok, _solution} ->
        conn
        |> put_flash(:info, gettext("Solution created successfully"))
        |> redirect(
          to: Routes.player_tournament_tour_path(conn, :show, tournament, tour)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _params) do
    changeset = Player.change_solution(conn.assigns.solution)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"solution" => params}) do
    tournament = conn.assigns.tournament
    tour = conn.assigns.tour
    solution = conn.assigns.solution

    case Player.update_solution(solution, solution_params(conn, params)) do
      {:ok, _solution} ->
        conn
        |> put_flash(:info, gettext("Solution updated successfully"))
        |> redirect(
          to: Routes.player_tournament_tour_path(conn, :show, tournament, tour)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", solution: solution, changeset: changeset)
    end
  end

  defp load_parent_resource(conn, _opts) do
    task = Game.get_task!(conn.params["task_id"])
    assign(conn, :task, task)
  end

  defp load_resource(conn, _opts) do
    solution =
      Player.get_solution(
        conn.assigns.task,
        conn.assigns.participation
      )

    assign(conn, :solution, solution)
  end

  defp solution_params(conn, params) do
    params
    |> Map.merge(%{
      "participation_id" => conn.assigns.participation.id,
      "task_id" => conn.assigns.task.id
    })
  end
end
