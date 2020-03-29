defmodule Ikvn.Repo.Migrations.CreateParticipations do
  use Ecto.Migration

  alias Ikvn.Game.Role

  def change do
    create table(:participations) do
      add :role, Role.type(), null: false, default: "player"

      add :tournament_id, references(:tournaments, on_delete: :delete_all),
        null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :creator_id, references(:users, on_delete: :nilify_all)
      timestamps(type: :utc_datetime)
    end

    create unique_index(:participations, [:user_id, :tournament_id],
      name: :participations_user_id_tournament_id_index)
    create index(:participations, [:tournament_id])
    create index(:participations, [:creator_id])
  end
end
