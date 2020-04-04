defmodule Ikvn.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE VIEW scores AS
        SELECT
          solutions.id AS solution_id,
          solutions.participation_id AS participation_id,
          solutions.task_id AS task_id,
          COALESCE(AVG(marks.value), 0)::float AS value
        FROM solutions
        LEFT OUTER JOIN marks
          ON solutions.id = marks.solution_id
        GROUP BY solutions.id
        ;
    """
  end

  def down do
    execute "DROP VIEW scores;"
  end
end
