defmodule Ikvn.Game.Solution do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ikvn.Game.Mark
  alias Ikvn.Game.Participation
  alias Ikvn.Game.Solution
  alias Ikvn.Game.Task

  schema "solutions" do
    field :content, :string

    belongs_to :participation, Participation
    belongs_to :task, Task

    has_many :marks, Mark

    timestamps(type: :utc_datetime)
  end

  def changeset(%Solution{} = user, attrs) do
    user
    |> cast(attrs, [:content, :participation_id, :task_id])
    |> validate_required([:content, :participation_id, :task_id])
    |> foreign_key_constraint(:participation_id)
    |> foreign_key_constraint(:task_id)
    |> unique_constraint(:task_id,
      name: :solutions_task_id_participation_id_index
    )
  end
end
