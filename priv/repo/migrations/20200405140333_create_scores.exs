defmodule Ikvn.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def up do
    execute """
      CREATE VIEW scores AS
        SELECT
          solutions.id AS solution_id,
          solutions.participation_id,
          solutions.task_id,
          tours.id AS tour_id,
          tours.tournament_id,
          COALESCE(AVG(marks.value), 0)::float AS value
        FROM solutions
        LEFT OUTER JOIN marks
          ON solutions.id = marks.solution_id
        LEFT OUTER JOIN tasks
          ON solutions.task_id = tasks.id
        LEFT OUTER JOIN tours
          ON tasks.tour_id = tours.id
        WHERE tours.results_at AT TIME ZONE 'UTC' <= NOW()
        GROUP BY solutions.id, tours.id
        ;
    """
  end

  def down do
    execute "DROP VIEW scores;"
  end
end
