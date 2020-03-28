defmodule Ikvn.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nickname, :text
      add :email, :text
      add :permissions, {:array, :text}, default: []

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:nickname])
  end
end
