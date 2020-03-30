defmodule Ikvn.Game.Tournament do
  use Ecto.Schema
  import Ecto.Changeset
  import Ikvn.Utils.Validation

  alias Ikvn.Account.User
  alias Ikvn.Game.Participation
  alias Ikvn.Game.Tour
  alias Ikvn.Game.Tournament

  schema "tournaments" do
    field :name, :string
    field :headline, :string
    field :description, :string
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime

    belongs_to :creator, User

    has_many :participations, Participation
    has_many :tours, Tour

    timestamps(type: :utc_datetime)
  end

  def changeset(%Tournament{} = tournament, attrs) do
    tournament
    |> cast(attrs, [
      :name, :headline, :description, :started_at, :finished_at, :creator_id
    ])
    |> validate_required([:name, :started_at, :finished_at, :creator_id])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:creator_id)
    |> forbid_change(:creator_id)
  end
end
