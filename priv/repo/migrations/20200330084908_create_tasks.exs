defmodule Ikvn.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :text
      add :description, :text, null: false
      add :order, :integer

      add :tour_id, references(:tours, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:tour_id])
  end
end
