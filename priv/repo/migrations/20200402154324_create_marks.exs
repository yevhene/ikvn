defmodule Ikvn.Repo.Migrations.CreateMarks do
  use Ecto.Migration

  def change do
    create table(:marks) do
      add :value, :integer, null: false

      add :participation_id,
          references(:participations, on_delete: :delete_all),
          null: false

      add :solution_id,
          references(:solutions, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    create index(:marks, [:participation_id])

    create unique_index(:marks, [:solution_id, :participation_id],
             name: :marks_solution_id_participation_id_index
           )
  end
end
