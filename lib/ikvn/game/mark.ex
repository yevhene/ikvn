defmodule Ikvn.Game.Mark do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ikvn.Game.Mark
  alias Ikvn.Game.Participation
  alias Ikvn.Game.Solution

  schema "marks" do
    field :value, :integer

    belongs_to :participation, Participation
    belongs_to :solution, Solution

    timestamps(type: :utc_datetime)
  end

  def changeset(%Mark{} = user, attrs) do
    user
    |> cast(attrs, [:value, :participation_id, :solution_id])
    |> validate_required([:value, :participation_id, :solution_id])
    |> foreign_key_constraint(:participation_id)
    |> foreign_key_constraint(:solution_id)
    |> unique_constraint(:task_id,
      name: :marks_solution_id_participation_id_index
    )
  end
end
