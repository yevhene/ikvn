defmodule IkvnWeb.Admin.TournamentController do
  use IkvnWeb, :controller

  alias Ikvn.Game
  alias Ikvn.Game.Tournament

  plug :put_layout, "admin.html" when action not in [:new, :create]

  def new(conn, _params) do
    changeset = Game.change_tournament(%Tournament{
      creator_id: conn.assigns.current_user.id,
      started_at: DateTime.utc_now,
      finished_at: DateTime.utc_now
    })
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tournament" => tournament_params}) do
    tournament_params = tournament_params(conn, tournament_params)

    case Game.create_tournament(tournament_params) do
      {:ok, tournament} ->
        {:ok, _participation} = Game.create_creator_participation(tournament)

        conn
        |> put_flash(:info, gettext "Tournament created successfully")
        |> redirect(to: Routes.tournament_path(conn, :show, tournament))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end

  def edit(conn, _params) do
    changeset = Game.change_tournament(conn.assigns.tournament)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"tournament" => tournament_params}) do
    tournament = conn.assigns.tournament
    tournament_params = tournament_params(conn, tournament_params)

    case Game.update_tournament(tournament, tournament_params) do
      {:ok, tournament} ->
        conn
        |> put_flash(:info, gettext "Tournament updated successfully")
        |> redirect(to: Routes.admin_tournament_path(conn, :show, tournament))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  defp tournament_params(conn, params) do
    params
    |> Map.merge(%{"creator_id" => conn.assigns.current_user.id})
  end
end
