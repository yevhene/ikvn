defmodule IkvnWeb.Admin.TaskController do
  use IkvnWeb, :controller
  alias Ikvn.Game
  alias Ikvn.Game.Task

  plug :load_resource when action in [:edit, :update, :delete]

  def new(conn, _params) do
    changeset = Game.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => params}) do
    tournament = conn.assigns.tournament
    tour = conn.assigns.tour

    case Game.create_task(task_params(conn, params)) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, gettext "Task created successfully")
        |> redirect(to:
          Routes.admin_tournament_tour_path(conn, :show, tournament, tour)
        )
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _params) do
    task = conn.assigns.task
    changeset = Game.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"task" => params}) do
    tournament = conn.assigns.tournament
    tour = conn.assigns.tour
    task = conn.assigns.task

    case Game.update_task(task, task_params(conn, params)) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, gettext "Task updated successfully")
        |> redirect(to:
          Routes.admin_tournament_tour_path(conn, :show, tournament, tour)
        )
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    tournament = conn.assigns.tournament
    tour = conn.assigns.tour
    task = conn.assigns.task

    case Game.delete_task(task) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, gettext "Task deleted successfully")
        |> redirect(to:
          Routes.admin_tournament_tour_path(conn, :show, tournament, tour)
        )
      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, gettext "Task can't be deleted")
        |> redirect(to:
          Routes.admin_tournament_tour_path(conn, :show, tournament, tour)
        )
    end
  end

  defp load_resource(conn, _opts) do
    task = Game.get_task!(conn.params["id"])
    assign(conn, :task, task)
  end

  defp task_params(conn, params) do
    params
    |> Map.merge(%{
      "tour_id" => conn.assigns.tour.id,
    })
  end
end
