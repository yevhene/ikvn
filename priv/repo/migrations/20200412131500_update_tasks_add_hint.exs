defmodule Ikvn.Repo.Migrations.UpdateTasksAddHint do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :hint, :text

      remove :order, :integer

      add :order, :integer, default: 0
    end
  end
end
