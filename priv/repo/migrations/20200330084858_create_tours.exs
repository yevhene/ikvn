defmodule Ikvn.Repo.Migrations.CreateTours do
  use Ecto.Migration

  def change do
    create table(:tours) do
      add :title, :text
      add :description, :text
      add :started_at, :utc_datetime, null: false
      add :finished_at, :utc_datetime, null: false
      add :results_at, :utc_datetime, null: false
      add :tournament_id, references(:tournaments, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tours, [:tournament_id])
  end
end
