defmodule Ikvn.Game.Participation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ikvn.Account.User
  alias Ikvn.Game.{Mark, Participation, Role, Solution, Tournament}
  alias Ikvn.Metrics.{Duty, Score, Submission}

  schema "participations" do
    field :role, Role

    belongs_to :tournament, Tournament
    belongs_to :user, User

    has_many :solutions, Solution
    has_many :marks, Mark

    has_many :duties, Duty
    has_many :scores, Score
    has_many :submissions, Submission

    timestamps(type: :utc_datetime)
  end

  def changeset(%Participation{} = participation, attrs) do
    participation
    |> cast(attrs, [:role, :tournament_id, :user_id])
    |> validate_required([:role, :tournament_id, :user_id])
    |> validate_inclusion(:role, Role.__valid_values__())
    |> unique_constraint(:tournament_id,
      name: :participations_user_id_tournament_id_index
    )
    |> foreign_key_constraint(:tournament_id)
    |> foreign_key_constraint(:user_id)
  end
end
