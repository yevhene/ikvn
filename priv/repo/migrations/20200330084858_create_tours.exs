defmodule Ikvn.Repo.Migrations.CreateTours do
  use Ecto.Migration

  def change do
    create table(:tours) do
      add :name, :text
      add :started_at, :utc_datetime, null: false
      add :finished_at, :utc_datetime, null: false
      add :results_at, :utc_datetime, null: false
      add :tournament_id, references(:tournaments, on_delete: :delete_all),
        null: false

      add :creator_id, references(:users, on_delete: :nilify_all)
      timestamps(type: :utc_datetime)
    end

    create index(:tours, [:tournament_id])
    create index(:tours, [:creator_id])
  end
end
