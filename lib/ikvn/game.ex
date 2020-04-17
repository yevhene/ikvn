defmodule Ikvn.Game do
  import Ecto.Query, warn: false
  alias Ikvn.Account.User
  alias Ikvn.Game.{Participation, Solution, Task, Tour, Tournament}
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
    list_public_tournaments()
    |> Repo.preload([participations:
      from(p in Participation, where: p.user_id == ^user_id)
    ])
  end

  def get_participation!(id), do: Repo.get(Participation, id)

  def create_participation(attrs \\ %{}) do
    %Participation{}
    |> Participation.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_participation(
    %User{id: user_id}, %Tournament{id: tournament_id}
  ) do
    Participation
    |> Repo.get_by(user_id: user_id, tournament_id: tournament_id)
  end

  def get_user_participation(_, _), do: nil

  def get_solution!(id), do: Repo.get!(Solution, id)

  def get_tour!(id), do: Repo.get!(Tour, id)

  def get_tour(id), do: Repo.get(Tour, id)

  def list_tours(%Tournament{id: tournament_id}) do
    Tour
    |> where([t], t.tournament_id == ^tournament_id)
    |> order_by(:started_at)
    |> Repo.all
  end

  def tournament_is_future?(%Tournament{started_at: started_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, started_at) == :lt
  end

  def tournament_is_active?(
    %Tournament{started_at: started_at, finished_at: finished_at
  }) do
    now = DateTime.utc_now
    DateTime.compare(now, started_at) == :gt and (
      finished_at == nil or DateTime.compare(now, finished_at) == :lt
    )
  end

  def tournament_is_finished?(%Tournament{finished_at: finished_at}) do
    now = DateTime.utc_now
    finished_at != nil and DateTime.compare(now, finished_at) == :gt
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

  def tournament_is_available?(nil, nil), do: false

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
end
