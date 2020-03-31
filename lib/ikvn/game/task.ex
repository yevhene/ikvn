defmodule Ikvn.Game.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ikvn.Game.Solution
  alias Ikvn.Game.Task
  alias Ikvn.Game.Tour

  schema "tasks" do
    field :title, :string
    field :order, :integer
    field :description, :string

    belongs_to :tour, Tour

    has_many :solutions, Solution

    timestamps(type: :utc_datetime)
  end

  def changeset(%Task{} = user, attrs) do
    user
    |> cast(attrs, [:title, :description, :order, :tour_id])
    |> validate_required([:description, :tour_id])
    |> foreign_key_constraint(:tour_id)
  end
end
