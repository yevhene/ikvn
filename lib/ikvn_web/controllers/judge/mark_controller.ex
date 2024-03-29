defmodule IkvnWeb.Judge.MarkController do
  use IkvnWeb, :controller
  alias Ikvn.{Game, Judge}
  alias IkvnWeb.Helpers

  plug :load_parent_resources
  plug :load_resource

  def create(conn, params) do
    case apply_mark(conn, params) do
      {:ok, _mark} ->
        conn
        |> redirect_back()

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(
          :error,
          gettext(
            "Can't apply mark. Reason: %{reason}",
            reason: Helpers.Error.fetch_errors(changeset)
          )
        )
        |> redirect_back()
    end
  end

  defp redirect_back(conn) do
    redirect(conn,
      to:
        Routes.judge_tournament_tour_task_path(
          conn,
          :show,
          conn.assigns.tournament,
          conn.assigns.tour,
          conn.assigns.task
        )
    )
  end

  defp apply_mark(conn, params) do
    mark = conn.assigns.mark

    if mark do
      Judge.update_mark(mark, %{value: params["value"]})
    else
      Judge.create_mark(%{
        participation_id: conn.assigns.participation.id,
        solution_id: conn.assigns.solution.id,
        value: params["value"]
      })
    end
  end

  defp load_parent_resources(conn, _opts) do
    task = Game.get_task!(conn.params["task_id"])
    solution = Game.get_solution!(conn.params["solution_id"])

    conn
    |> assign(:task, task)
    |> assign(:solution, solution)
  end

  defp load_resource(conn, _opts) do
    mark = Judge.get_mark(conn.assigns.solution, conn.assigns.participation)
    assign(conn, :mark, mark)
  end
end
