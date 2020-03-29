defmodule Ikvn.Game.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ikvn.Account.User
  alias Ikvn.Game.Participation
  alias Ikvn.Game.Tournament

  schema "tournaments" do
    field :name, :string
    field :headline, :string
    field :description, :string
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime

    belongs_to :creator, User

    has_many :participations, Participation

    timestamps(type: :utc_datetime)
  end

  def changeset(%Tournament{} = user, attrs) do
    user
    |> cast(attrs, [
      :name, :headline, :description, :creator_id, :started_at, :finished_at
    ])
    |> validate_required([:name, :creator_id])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:creator_id)
  end
end
