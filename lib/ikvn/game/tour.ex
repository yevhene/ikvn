defmodule Ikvn.Game.Tour do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ikvn.Game.{Task, Tour, Tournament}

  schema "tours" do
    field :title, :string
    field :description, :string
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime
    field :results_at, :utc_datetime

    belongs_to :tournament, Tournament

    has_many :tasks, Task

    timestamps(type: :utc_datetime)
  end

  def changeset(%Tour{} = user, attrs) do
    user
    |> cast(attrs, [
      :title, :description, :started_at, :finished_at,
      :results_at, :tournament_id
    ])
    |> validate_required([
      :started_at, :finished_at, :results_at
    ])
    |> foreign_key_constraint(:tournament_id)
  end
end
