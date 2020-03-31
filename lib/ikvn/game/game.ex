defmodule Ikvn.Game do
  import Ecto.Query, warn: false
  import IkvnWeb.Gettext

  alias Ikvn.Account
  alias Ikvn.Account.User
  alias Ikvn.Game.Participation
  alias Ikvn.Game.Task
  alias Ikvn.Game.Tour
  alias Ikvn.Game.Tournament
  alias Ikvn.Repo

  def get_tournament(id), do: Repo.get(Tournament, id)

  def list_public_tournaments do
    now = DateTime.utc_now

    Tournament
    |> where([t], t.started_at <= ^now)
    |> order_by(:started_at)
    |> Repo.all
    |> Repo.preload(:creator)
  end

  def list_future_tournaments(nil), do: []

  def list_future_tournaments(%User{} = user) do
    now = DateTime.utc_now

    Tournament
    |> where([t], t.started_at > ^now)
    |> join(:inner, [t], p in Participation, on:
      t.id == p.tournament_id and
      p.user_id == ^user.id and
      p.role in ["admin", "judge"]
    )
    |> order_by(:started_at)
    |> Repo.all
    |> Repo.preload(:creator)
  end

  def change_tournament(%Tournament{} = tournament) do
    Tournament.changeset(tournament, %{})
  end

  def create_tournament(attrs \\ %{}, %User{} = creator) do
    %Tournament{}
    |> Tournament.changeset(Map.put(attrs, "creator_id", creator.id))
    |> Repo.insert()
  end

  def update_tournament(%Tournament{} = tournament, attrs) do
    tournament
    |> Tournament.changeset(attrs)
    |> Repo.update()
  end

  def create_creator_participation(%Tournament{
    id: id, creator_id: creator_id
  }) do
    create_participation(%{
      tournament_id: id,
      user_id: creator_id,
      creator_id: creator_id,
      role: :admin
    })
  end

  def list_participations(%Tournament{id: id}, roles) do
    Participation
    |> where([p],
      p.tournament_id == ^id and p.role in ^roles
    )
    |> order_by(:inserted_at)
    |> Repo.all
    |> Repo.preload(:user)
  end

  def create_staff(nickname, role, tournament, creator) do
    case Account.find_user(nickname) do
      %User{} = user ->
        create_participation(%{
          tournament_id: tournament.id,
          user_id: user.id,
          role: role,
          creator_id: creator.id
        })
      _ ->
        {:error, gettext(
          "User \"%{nickname}\" is not exist", nickname: nickname
        )}
    end
  end

  def get_participation!(id), do: Repo.get(Participation, id)

  def create_participation(attrs \\ %{}) do
    %Participation{}
    |> Participation.changeset(attrs)
    |> Repo.insert()
  end

  def delete_participation(%Participation{} = participation) do
    participation = participation |> Repo.preload(:tournament)
    if participation.tournament.creator_id == participation.user_id do
      {:error, gettext("Can't delete the Creator from staff")}
    else
      participation
      |> Repo.delete()
    end
  end

  def get_user_participation(
    %User{id: user_id}, %Tournament{id: tournament_id}
  ) do
    Participation
    |> Repo.get_by(user_id: user_id, tournament_id: tournament_id)
  end

  def get_user_participation(_, _), do: nil

  def get_tour!(id), do: Repo.get!(Tour, id)

  def list_tours(%Tournament{id: tournament_id}) do
    Tour
    |> where([t], t.tournament_id == ^tournament_id)
    |> order_by(:started_at)
    |> Repo.all
  end

  def change_tour(%Tour{} = tour) do
    Tour.changeset(tour, %{})
  end

  def create_tour(attrs \\ %{}, %User{} = creator) do
    %Tour{}
    |> Tour.changeset(Map.put(attrs, "creator_id", creator.id))
    |> Repo.insert()
  end

  def update_tour(%Tour{} = tour, attrs) do
    tour
    |> Tour.changeset(attrs)
    |> Repo.update()
  end

  def delete_tour(%Tour{} = tour) do
    Repo.delete(tour)
  end

  def is_future?(%Tournament{started_at: started_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, started_at) == :lt
  end

  def is_future?(%Tour{started_at: started_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, started_at) == :lt
  end

  def is_active?(%Tournament{
    started_at: started_at, finished_at: finished_at
  }) do
    now = DateTime.utc_now
    DateTime.compare(now, started_at) == :gt and
      DateTime.compare(now, finished_at) == :lt
  end

  def is_active?(%Tour{started_at: started_at, finished_at: finished_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, started_at) == :gt and
      DateTime.compare(now, finished_at) == :lt
  end

  def is_finished?(%Tournament{finished_at: finished_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, finished_at) == :gt
  end

  def is_judging?(%Tour{finished_at: finished_at, results_at: results_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, finished_at) == :gt and
      DateTime.compare(now, results_at) == :lt
  end

  def is_closed?(%Tour{results_at: results_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, results_at) == :gt
  end

  def get_task!(id), do: Repo.get!(Task, id)

  def list_tasks(%Tour{id: tour_id}) do
    Task
    |> where([t], t.tour_id == ^tour_id)
    |> order_by([asc: :order, desc: :inserted_at])
    |> Repo.all
  end

  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  def create_task(attrs \\ %{}, %User{} = creator) do
    %Task{}
    |> Task.changeset(Map.put(attrs, "creator_id", creator.id))
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end
end
