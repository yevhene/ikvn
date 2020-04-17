defmodule Ikvn.Repo.Migrations.UpdateForeignKeysOnDelete do
  use Ecto.Migration

  def change do
    alter table(:participations) do
      modify :user_id,
             references(:users, on_delete: :restrict),
             from: references(:users, on_delete: :delete_all)
    end

    alter table(:tours) do
      modify :tournament_id,
             references(:tournaments, on_delete: :restrict),
             from: references(:tournaments, on_delete: :delete_all)
    end

    alter table(:tasks) do
      modify :tour_id,
             references(:tours, on_delete: :restrict),
             from: references(:tours, on_delete: :delete_all)
    end

    alter table(:solutions) do
      modify :participation_id,
             references(:participations, on_delete: :restrict),
             from: references(:participations, on_delete: :delete_all)

      modify :task_id,
             references(:tasks, on_delete: :restrict),
             from: references(:tasks, on_delete: :delete_all)
    end

    alter table(:marks) do
      modify :participation_id,
             references(:participations, on_delete: :restrict),
             from: references(:participations, on_delete: :delete_all)

      modify :solution_id,
             references(:solutions, on_delete: :restrict),
             from: references(:solutions, on_delete: :delete_all)
    end
  end
end
