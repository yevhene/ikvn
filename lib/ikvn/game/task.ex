defmodule Ikvn.Game.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ikvn.Account.User
  alias Ikvn.Game.Task
  alias Ikvn.Game.Tour

  schema "tasks" do
    field :title, :string
    field :content, :string

    belongs_to :tour, Tour
    belongs_to :creator, User

    timestamps(type: :utc_datetime)
  end

  def changeset(%Task{} = user, attrs) do
    user
    |> cast(attrs, [:title, :content, :tour_id, :creator_id])
    |> validate_required([:content, :tour_id, :creator_id])
    |> foreign_key_constraint(:tour_id)
    |> foreign_key_constraint(:creator_id)
  end
end