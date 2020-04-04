defmodule Ikvn.Game do
  import Ecto.Query, warn: false
  import Ecto.Changeset
  import IkvnWeb.Gettext

  alias Ikvn.Account
  alias Ikvn.Account.User
  alias Ikvn.Game.Mark
  alias Ikvn.Game.Participation
  alias Ikvn.Game.Solution
  alias Ikvn.Game.Task
  alias Ikvn.Game.Tour
  alias Ikvn.Game.Tournament
  alias Ikvn.Repo

  def get_tournament(id), do: Repo.get(Tournament, id)

  def list_public_tournaments(user \\ nil)

  def list_public_tournaments(nil) do
    now = DateTime.utc_now

    Tournament
    |> where([t], t.started_at <= ^now)
    |> order_by(:started_at)
    |> Repo.all
  end

  def list_public_tournaments(%User{id: user_id}) do
    list_public_tournaments(nil)
    |> Repo.preload([participations:
      from(p in Participation, where: p.user_id == ^user_id)
    ])
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

  def create_creator_participation(%Tournament{
    id: id, creator_id: creator_id
  }) do
    create_participation(%{
      tournament_id: id,
      user_id: creator_id,
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

  def create_staff(nickname, role, tournament) do
    case Account.find_user(nickname) do
      %User{} = user ->
        create_participation(%{
          tournament_id: tournament.id,
          user_id: user.id,
          role: role
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
      |> change
      |> no_assoc_constraint(:soultions)
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

  def get_tour(id), do: Repo.get(Tour, id)

  def list_tours(%Tournament{id: tournament_id}) do
    Tour
    |> where([t], t.tournament_id == ^tournament_id)
    |> order_by(:started_at)
    |> Repo.all
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

  def tournament_is_future?(%Tournament{started_at: started_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, started_at) == :lt
  end

  def tournament_is_active?(
    %Tournament{started_at: started_at, finished_at: finished_at
  }) do
    now = DateTime.utc_now
    DateTime.compare(now, started_at) == :gt and
      DateTime.compare(now, finished_at) == :lt
  end

  def tournament_is_finished?(%Tournament{finished_at: finished_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, finished_at) == :gt
  end

  def tour_is_future?(%Tour{started_at: started_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, started_at) == :lt
  end

  def tour_is_active?(%Tour{
    started_at: started_at, finished_at: finished_at
  }) do
    now = DateTime.utc_now
    DateTime.compare(now, started_at) == :gt and
      DateTime.compare(now, finished_at) == :lt
  end

  def tour_is_judging?(%Tour{
    finished_at: finished_at, results_at: results_at
  }) do
    now = DateTime.utc_now
    DateTime.compare(now, finished_at) == :gt and
      DateTime.compare(now, results_at) == :lt
  end

  def tour_is_closed?(%Tour{results_at: results_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, results_at) == :gt
  end

  def tournament_is_available?(%Tournament{}, %Participation{}), do: true

  def tournament_is_available?(%Tournament{} = tournament, nil) do
    not tournament_is_future?(tournament)
  end

  def tour_is_available?(%Tour{} = tour, role) do
    case role do
      :admin -> true
      :judge -> not tour_is_future?(tour)
      :player -> not tour_is_future?(tour)
      _ -> false
    end
  end

  def get_task!(id), do: Repo.get!(Task, id)

  def list_tasks(%Tour{id: tour_id}) do
    Task
    |> where([t], t.tour_id == ^tour_id)
    |> order_by([asc: :order, asc: :inserted_at])
    |> Repo.all
  end

  def list_tasks(
    %Tour{} = tour, %Participation{role: role} = participation
  ) when role == :admin or role == :judge do
    list_tasks(tour)
    |> Repo.preload([solutions:
      from(s in Solution,
        left_join: m in Mark,
        on: m.solution_id == s.id and m.participation_id == ^participation.id,
        preload: [marks: m]
      )
    ])
  end

  def list_tasks(%Tour{} = tour, %Participation{
    id: participation_id, role: :player
  }) do
    list_tasks(tour)
    |> Repo.preload([solutions:
      from(s in Solution, where: s.participation_id == ^participation_id)
    ])
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

  def list_solutions(
    %Task{} = task, %Participation{role: role} = participation
  ) when role == :admin or role == :judge do
    Solution
    |> where([s], s.task_id == ^task.id)
    |> order_by(fragment("md5(inserted_at::text) ASC"))
    |> Repo.all
    |> Repo.preload([marks:
      from(m in Mark, where: m.participation_id == ^participation.id)
    ])
  end

  def get_solution!(id), do: Repo.get!(Solution, id)

  def get_solution(%Task{id: task_id}, %Participation{id: participation_id}) do
    Solution
    |> where([s],
      s.task_id == ^task_id and
      s.participation_id == ^participation_id
    )
    |> Repo.one
  end

  def change_solution(%Solution{} = solution) do
    Solution.changeset(solution, %{})
  end

  def create_solution(attrs \\ %{}) do
    %Solution{}
    |> Solution.changeset(attrs)
    |> Repo.insert()
  end

  def update_solution(%Solution{} = solution, attrs) do
    solution
    |> Solution.changeset(attrs)
    |> Repo.update()
  end

  def get_mark(
    %Solution{id: solution_id}, %Participation{id: participation_id}
  ) do
    Mark
    |> Repo.get_by(solution_id: solution_id, participation_id: participation_id)
  end

  def change_mark(%Mark{} = mark) do
    Mark.changeset(mark, %{})
  end

  def create_mark(attrs \\ %{}) do
    %Mark{}
    |> Mark.changeset(attrs)
    |> Repo.insert()
  end

  def update_mark(%Mark{} = mark, attrs) do
    mark
    |> Mark.changeset(attrs)
    |> Repo.update()
  end
end
