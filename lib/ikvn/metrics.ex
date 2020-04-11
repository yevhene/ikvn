defmodule Ikvn.Metrics do
  import Ecto.Query, warn: false
  alias Ikvn.Game.{Participation, Solution, Task, Tour, Tournament}
  alias Ikvn.Metrics.Score
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
    |> add_result_place()

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
        total: Enum.sum(tasks) |> Float.round(1)
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

  defp add_result_place(results) do
    results
    |> Enum.map(&(&1[:total]))
    |> Enum.zip(1..(Enum.count(results)))
    |> Enum.chunk_by(fn {score, _place} -> score end)
    |> Enum.flat_map(fn chunk ->
      {_score, place} = Enum.at(chunk, 0)
      Enum.map(1..Enum.count(chunk), fn _number -> place end)
    end)
    |> Enum.zip(results)
    |> Enum.map(fn {place, result} -> Map.put(result, :place, place) end)
  end

  def get_digest(%Tournament{id: tournament_id}) do
    now = DateTime.utc_now

    Tour
    |> where([t], t.tournament_id == ^tournament_id)
    |> where([t], t.results_at <= ^now)
    |> order_by([desc: :started_at])
    |> Repo.all
    |> Repo.preload([tasks:
      from(t in Task,
        order_by: [asc: t.order, asc: t.inserted_at],
        preload: ^[solutions:
          from(s in Solution,
            join: score in Score, on: s.id == score.solution_id,
            where: score.place <= 5,
            order_by: [score.place, s.inserted_at],
            preload: [:score, [participation: :user]]
          )
        ]
      )
    ])
  end
end
