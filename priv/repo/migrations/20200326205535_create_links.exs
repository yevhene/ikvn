defmodule Ikvn.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :uid, :string, null: false
      add :data, :jsonb

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:links, [:uid])
    create index(:links, [:user_id])
  end
end
