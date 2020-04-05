defmodule Ikvn.Repo.Migrations.CreateDuties do
  use Ecto.Migration

  def up do
    execute """
      CREATE VIEW duties AS
        WITH overall AS (
          SELECT
            tasks.tour_id,
            solutions.task_id,
            COUNT(solutions.id) AS count
          FROM solutions
            INNER JOIN tasks
              ON solutions.task_id = tasks.id
          GROUP BY tasks.tour_id, solutions.task_id
        ),
        done AS (
          SELECT
            participations.id AS participation_id,
            participations.tournament_id,
            tasks.tour_id,
            tasks.id AS task_id,
            COUNT(marks.id) AS count
          FROM participations
            CROSS JOIN tasks
            INNER JOIN tours
              ON tasks.tour_id = tours.id
            LEFT OUTER JOIN solutions
              ON tasks.id = solutions.task_id
            LEFT OUTER JOIN marks
              ON marks.solution_id = solutions.id
                AND marks.participation_id = participations.id
          WHERE participations.tournament_id = tours.tournament_id
            AND participations.role IN ('admin', 'judge')
            AND tours.finished_at AT TIME ZONE 'UTC' <= NOW()
          GROUP BY participations.id, tasks.id
        )
        SELECT
          done.participation_id,
          done.tournament_id,
          done.tour_id,
          done.task_id,
          COALESCE(overall.count, 0)::int AS all,
          COALESCE(done.count, 0)::int AS done,
          (
            COALESCE(overall.count, 0) - COALESCE(done.count, 0)
          )::int AS left
        FROM done
          LEFT OUTER JOIN overall
            ON done.task_id = overall.task_id
        ;
    """
  end

  def down do
    execute "DROP VIEW duties;"
  end
end
