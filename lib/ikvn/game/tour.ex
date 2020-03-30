defmodule Ikvn.Game.Tour do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ikvn.Account.User
  alias Ikvn.Game.Task
  alias Ikvn.Game.Tour
  alias Ikvn.Game.Tournament

  schema "tours" do
    field :name, :string
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime
    field :results_at, :utc_datetime

    belongs_to :tournament, Tournament
    belongs_to :creator, User

    has_many :tasks, Task

    timestamps(type: :utc_datetime)
  end

  def changeset(%Tour{} = user, attrs) do
    user
    |> cast(attrs, [
      :name, :started_at, :finished_at, :results_at, :tournament_id, :creator_id
    ])
    |> validate_required([
      :started_at, :finished_at, :results_at, :creator_id
    ])
    |> foreign_key_constraint(:tournament_id)
    |> foreign_key_constraint(:creator_id)
  end
end
