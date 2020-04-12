defmodule Ikvn.Player do
  import Ecto.Query, warn: false
  alias Ikvn.{Game, Repo}
  alias Ikvn.Game.{Participation, Solution, Task, Tour}

  def list_tasks(%Tour{} = tour, %Participation{
    id: participation_id, role: :player
  }) do
    tour
    |> Game.list_tasks
    |> Repo.preload([solutions:
      from(s in Solution,
        where: s.participation_id == ^participation_id,
        preload: [:score])
    ])
  end

  def create_player_participation(attrs \\ %{}) do
    %Participation{}
    |> Participation.changeset(Map.put(attrs, "role", :player))
    |> Repo.insert()
  end

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
end
