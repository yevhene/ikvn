defmodule Ikvn.Judge do
  import Ecto.Query, warn: false
  alias Ikvn.Game
  alias Ikvn.Game.{Mark, Participation, Solution, Task, Tour}
  alias Ikvn.Metrics.Duty
  alias Ikvn.Repo

  def list_tasks(
    %Tour{} = tour, %Participation{role: role} = participation
  ) when role == :admin or role == :judge do
    tour
    |> Game.list_tasks
    |> Repo.preload([duties:
      from(d in Duty, where: d.participation_id == ^participation.id)
    ])
  end

  def list_solutions(
    %Task{} = task, %Participation{role: role} = participation
  ) when role == :admin or role == :judge do
    Solution
    |> where([s], s.task_id == ^task.id)
    |> order_by(fragment("md5(inserted_at::text) ASC"))
    |> Repo.all
    |> Repo.preload([[participation: :user], [marks:
      from(m in Mark, where: m.participation_id == ^participation.id)
    ]])
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
