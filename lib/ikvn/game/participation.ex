defmodule Ikvn.Game.Participation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ikvn.Account.User
  alias Ikvn.Game.Mark
  alias Ikvn.Game.Participation
  alias Ikvn.Game.Role
  alias Ikvn.Game.Solution
  alias Ikvn.Game.Tournament
  alias Ikvn.Metrics.Duty

  schema "participations" do
    field :role, Role

    belongs_to :tournament, Tournament
    belongs_to :user, User

    has_many :solutions, Solution
    has_many :marks, Mark
    has_many :duties, Duty

    timestamps(type: :utc_datetime)
  end

  def changeset(%Participation{} = participation, attrs) do
    participation
    |> cast(attrs, [:role, :tournament_id, :user_id])
    |> validate_required([:tournament_id, :user_id])
    |> unique_constraint(:tournament_id,
      name: :participations_user_id_tournament_id_index
    )
    |> foreign_key_constraint(:tournament_id)
    |> foreign_key_constraint(:user_id)
    |> validate_inclusion(:role, Role.__valid_values__())
  end
end
