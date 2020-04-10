defmodule Ikvn.Metrics.Duty do
  use Ecto.Schema

  alias Ikvn.Game.Participation
  alias Ikvn.Game.Task
  alias Ikvn.Game.Tour

  @primary_key false
  schema "duties" do
    field :all, :integer
    field :done, :integer
    field :left, :integer

    belongs_to :participation, Participation
    belongs_to :task, Task
    belongs_to :tour, Tour
  end
end