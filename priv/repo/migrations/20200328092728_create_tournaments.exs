defmodule Ikvn.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments) do
      add :name, :text, null: false
      add :headline, :text
      add :description, :text
      add :started_at, :utc_datetime
      add :finished_at, :utc_datetime

      add :creator_id, references(:users, on_delete: :nilify_all)
      timestamps(type: :utc_datetime)
    end

    create unique_index(:tournaments, [:name])
    create index(:tournaments, [:creator_id])
  end
end
