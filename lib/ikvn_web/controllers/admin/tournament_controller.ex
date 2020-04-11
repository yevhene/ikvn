defmodule IkvnWeb.Admin.TournamentController do
  use IkvnWeb, :controller

  alias Ikvn.Game
  alias Ikvn.Game.Tournament

  def new(conn, _params) do
    changeset = Game.change_tournament(%Tournament{
      started_at: DateTime.utc_now,
      finished_at: DateTime.utc_now
    })
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tournament" => params}) do
    case Game.create_tournament(tournament_params(conn, params)) do
      {:ok, tournament} ->
        {:ok, _participation} = Game.create_creator_participation(tournament)
        conn
        |> put_flash(:info, gettext "Tournament created successfully")
        |> redirect(to: Routes.admin_tournament_path(conn, :show, tournament))
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

  def update(conn, %{"tournament" => params}) do
    tournament = conn.assigns.tournament

    case Game.update_tournament(tournament, tournament_params(conn, params)) do
      {:ok, tournament} ->
        conn
        |> put_flash(:info, gettext "Tournament updated successfully")
        |> redirect(to: Routes.admin_tournament_path(conn, :show, tournament))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    tournament = conn.assigns.tournament

    case Game.delete_tournament(tournament) do
      {:ok, _tournament} ->
        conn
        |> put_flash(:info, gettext "Tournament deleted successfully")
        |> redirect(to: Routes.tournament_path(conn, :index))
      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, gettext "Tournament can't be deleted")
        |> redirect(to: Routes.admin_tournament_path(conn, :show, tournament))
    end
  end

  def tournament_params(conn, params) do
    params
    |> cast_datetime_params(["started_at"], conn.assigns.browser_timezone)
    |> Map.merge(%{
      "creator_id" => conn.assigns.current_user.id,
    })
  end
end
