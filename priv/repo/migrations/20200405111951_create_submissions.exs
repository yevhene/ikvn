defmodule Ikvn.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def up do
    execute """
      CREATE VIEW submissions AS
        WITH overall AS (
          SELECT
            tasks.tour_id,
            COUNT(tasks.id) AS count
          FROM tasks
          GROUP BY tasks.tour_id
        ),
        done AS (
          SELECT
            participations.id AS participation_id,
            participations.tournament_id,
            tours.id AS tour_id,
            COUNT(solutions.id) AS count
          FROM participations
            CROSS JOIN tours
            LEFT OUTER JOIN tasks
              ON tours.id = tasks.tour_id
            LEFT OUTER JOIN solutions
              ON tasks.id = solutions.task_id
                AND participations.id = solutions.participation_id
          WHERE participations.tournament_id = tours.tournament_id
            AND participations.role = 'player'
            AND tours.started_at AT TIME ZONE 'UTC' <= NOW()
          GROUP BY participations.id, tours.id
        )
        SELECT
          done.participation_id,
          done.tournament_id,
          done.tour_id,
          COALESCE(overall.count, 0)::int AS all,
          COALESCE(done.count, 0)::int AS done,
          (
            COALESCE(overall.count, 0) - COALESCE(done.count, 0)
          )::int AS left
        FROM done
          LEFT OUTER JOIN overall
            ON done.tour_id = overall.tour_id
        ;
    """
  end

  def down do
    execute "DROP VIEW submissions;"
  end
end
