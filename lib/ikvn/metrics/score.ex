defmodule Ikvn.Metrics.Score do
  use Ecto.Schema

  alias Ikvn.Game.Solution

  @primary_key false
  schema "scores" do
    field :value, :float

    belongs_to :solution, Solution
  end
end
