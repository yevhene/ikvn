defmodule IkvnWeb.Admin.TourController do
  use IkvnWeb, :controller
  alias Ikvn.{Admin, Game}
  alias Ikvn.Game.Tour

  plug :load_resource when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    tours = Game.list_tours(conn.assigns.tournament)
    render(conn, "index.html", tours: tours)
  end

  def new(conn, _params) do
    changeset =
      Admin.change_tour(%Tour{
        started_at: DateTime.utc_now(),
        finished_at: DateTime.utc_now(),
        results_at: DateTime.utc_now()
      })

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tour" => params}) do
    tournament = conn.assigns.tournament

    case Admin.create_tour(tour_params(conn, params)) do
      {:ok, _tour} ->
        conn
        |> put_flash(:info, gettext("Tour created successfully"))
        |> redirect(
          to: Routes.admin_tournament_tour_path(conn, :index, tournament)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    tasks = Game.list_tasks(conn.assigns.tour)
    render(conn, "show.html", tasks: tasks)
  end

  def edit(conn, _params) do
    changeset = Admin.change_tour(conn.assigns.tour)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"tour" => params}) do
    tournament = conn.assigns.tournament
    tour = conn.assigns.tour

    case Admin.update_tour(tour, tour_params(conn, params)) do
      {:ok, _tour} ->
        conn
        |> put_flash(:info, gettext("Tour updated successfully"))
        |> redirect(
          to: Routes.admin_tournament_tour_path(conn, :index, tournament)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tour: tour, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    tournament = conn.assigns.tournament
    tour = conn.assigns.tour

    case Admin.delete_tour(tour) do
      {:ok, _tour} ->
        conn
        |> put_flash(:info, gettext("Tour deleted successfully"))
        |> redirect(
          to: Routes.admin_tournament_tour_path(conn, :index, tournament)
        )

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, gettext("Tour can't be deleted"))
        |> redirect(
          to: Routes.admin_tournament_tour_path(conn, :show, tournament, tour)
        )
    end
  end

  defp load_resource(conn, _opts) do
    tour = Game.get_tour!(conn.params["id"])
    assign(conn, :tour, tour)
  end

  defp tour_params(conn, params) do
    params
    |> cast_datetime_params(
      ["started_at", "finished_at", "results_at"],
      conn.assigns.browser_timezone
    )
    |> Map.merge(%{
      "tournament_id" => conn.assigns.tournament.id
    })
  end
end
