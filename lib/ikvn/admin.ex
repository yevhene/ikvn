defmodule Ikvn.Admin do
  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Ikvn.Account.User
  alias Ikvn.Game
  alias Ikvn.Game.{Participation, Task, Tour, Tournament}
  alias Ikvn.Metrics.{Duty, Submission}
  alias Ikvn.Repo

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

  def create_tournament(attrs \\ %{}) do
    %Tournament{}
    |> Tournament.changeset(attrs)
    |> Repo.insert()
  end

  def update_tournament(%Tournament{} = tournament, attrs) do
    tournament
    |> Tournament.changeset(attrs)
    |> Repo.update()
  end

  def delete_tournament(%Tournament{} = tournament) do
    tournament
    |> change
    |> no_assoc_constraint(:tours)
    |> Repo.delete()
  end

  def finish_tournament(%Tournament{} = tournament) do
    now = DateTime.utc_now

    tournament
    |> Tournament.changeset(%{finished_at: now})
    |> Repo.update()
  end

  def create_creator_participation(%Tournament{
    id: id, creator_id: creator_id
  }) do
    Game.create_participation(%{
      tournament_id: id,
      user_id: creator_id,
      role: :admin
    })
  end

  def list_players(%Tournament{} = tournament) do
    list_participations(tournament, [:player])
    |> Repo.preload([submissions:
      from(s in Submission,
        join: t in Tour, on: s.tour_id == t.id,
        order_by: t.started_at
      )
    ])
  end

  def list_staff(%Tournament{} = tournament) do
    list_participations(tournament, [:admin, :judge])
    |> Repo.preload([duties:
      from(d in Duty,
        join: t in Tour, on: d.tour_id == t.id,
        group_by: [d.participation_id, t.id],
        select: %{
          participation_id: d.participation_id,
          tour_id: t.id,
          all: sum(d.all),
          done: sum(d.done),
          left: sum(d.left)
        },
        order_by: t.started_at
      )
    ])
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

  def delete_participation(%Participation{} = participation) do
    participation
    |> change
    |> no_assoc_constraint(:solutions)
    |> no_assoc_constraint(:marks)
    |> Repo.delete()
  end

  def change_tour(%Tour{} = tour) do
    Tour.changeset(tour, %{})
  end

  def create_tour(attrs \\ %{}) do
    %Tour{}
    |> Tour.changeset(attrs)
    |> Repo.insert()
  end

  def update_tour(%Tour{} = tour, attrs) do
    tour
    |> Tour.changeset(attrs)
    |> Repo.update()
  end

  def delete_tour(%Tour{} = tour) do
    tour
    |> change
    |> no_assoc_constraint(:tasks)
    |> Repo.delete()
  end

  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    task
    |> change
    |> no_assoc_constraint(:solutions)
    |> Repo.delete()
  end
end
