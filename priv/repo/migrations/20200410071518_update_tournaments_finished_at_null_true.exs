defmodule Ikvn.Repo.Migrations.UpdateTournamentsFinishedAtNullTrue do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      modify :finished_at, :utc_datetime, null: true,
        from: [:utc_datetime, null: false]
    end
  end
end
