defmodule Ikvn.Metrics.Score do
  use Ecto.Schema
  alias Ikvn.Game.{Participation, Solution, Task, Tour, Tournament}

  @primary_key false
  schema "scores" do
    field :value, :float
    field :place, :integer

    belongs_to :solution, Solution

    belongs_to :participation, Participation
    belongs_to :task, Task
    belongs_to :tour, Tour
    belongs_to :tournament, Tournament
  end
end
