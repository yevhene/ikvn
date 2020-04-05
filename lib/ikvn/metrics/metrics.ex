defmodule Ikvn.Metrics do
  import Ecto.Query, warn: false

  alias Ikvn.Game.Participation
  alias Ikvn.Game.Task
  alias Ikvn.Game.Tour
  alias Ikvn.Game.Tournament
  alias Ikvn.Repo

  def list_results(%Tournament{id: tournament_id}) do
    now = DateTime.utc_now

    tours = Tour
    |> where([t], t.results_at <= ^now)
    |> order_by(:started_at)
    |> Repo.all()
    |> Repo.preload([tasks:
      from(task in Task, order_by: [asc: :order, asc: :inserted_at])
    ])

    participations = Participation
    |> where([p], p.tournament_id == ^tournament_id)
    |> where([p], p.role == "player")
    |> Repo.all()
    |> Repo.preload([:user, :scores])

    results = participations
    |> Enum.map(&(results_row(&1, tours)))
    |> Enum.sort_by(&(&1[:total]), :desc)
    |> Enum.filter(&(&1[:total] > 0))

    {results, tours}
  end

  defp results_row(%Participation{} = participation, tours) do
    tours = result_tours(participation, tours)
    total = tours |> Enum.map(&(&1[:total])) |> Enum.sum()
    %{
      nickname: participation.user.nickname,
      tours: tours,
      total: total
    }
  end

  defp result_tours(%Participation{} = participation, tours) do
    tours
    |> Enum.map(fn tour ->
      tasks = result_tasks(participation, tour.tasks)
      %{
        tasks: tasks,
        total: Enum.sum(tasks)
      }
    end)
  end

  defp result_tasks(%Participation{} = participation, tasks) do
    tasks
    |> Enum.map(fn task ->
      score = Enum.find(participation.scores, fn score ->
        score.task_id == task.id
      end)
      if score == nil do
        0.0
      else
        score.value
      end
    end)
  end
end
