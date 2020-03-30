defmodule Ikvn.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :text
      add :content, :text, null: false
      add :tour_id, references(:tours, on_delete: :delete_all), null: false

      add :creator_id, references(:users, on_delete: :nilify_all)
      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:tour_id])
    create index(:tasks, [:creator_id])
  end
end
