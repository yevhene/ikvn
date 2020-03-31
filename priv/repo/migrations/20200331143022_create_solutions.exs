defmodule Ikvn.Repo.Migrations.CreateSolutions do
  use Ecto.Migration

  def change do
    create table(:solutions) do
      add :content, :text, null: false

      add :participation_id,
        references(:participations, on_delete: :delete_all), null: false
      add :task_id, references(:tasks, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:solutions, [:participation_id])
    create unique_index(:solutions, [:task_id, :participation_id],
      name: :solutions_task_id_participation_id_index)
  end
end
