defmodule Ikvn.Game do
  import Ecto.Query, warn: false
  import IkvnWeb.Gettext

  alias Ikvn.Account
  alias Ikvn.Account.User
  alias Ikvn.Game.Participation
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
    |> where([t],
      is_nil(t.started_at) or t.started_at > ^now
    )
    |> join(:inner, [t], p in Participation, on:
      t.id == p.tournament_id and p.user_id == ^user.id and p.role == "admin"
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

  def is_future?(%Tournament{started_at: started_at}) do
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

  def is_finished?(%Tournament{finished_at: finished_at}) do
    now = DateTime.utc_now
    DateTime.compare(now, finished_at) == :gt
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

  def change_participation(attrs \\ %{}) do
    %Participation{}
    |> Participation.changeset(attrs)
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
end
