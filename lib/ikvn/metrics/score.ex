defmodule Ikvn.Metrics.Score do
  use Ecto.Schema

  alias Ikvn.Game.Participation
  alias Ikvn.Game.Solution
  alias Ikvn.Game.Task
  alias Ikvn.Game.Tour
  alias Ikvn.Game.Tournament

  @primary_key false
  schema "scores" do
    field :value, :float

    belongs_to :solution, Solution

    belongs_to :participation, Participation
    belongs_to :task, Task
    belongs_to :tour, Tour
    belongs_to :tournament, Tournament
  end
end
