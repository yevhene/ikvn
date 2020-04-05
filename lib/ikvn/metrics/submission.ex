defmodule Ikvn.Metrics.Submission do
  use Ecto.Schema

  alias Ikvn.Game.Participation
  alias Ikvn.Game.Tour

  @primary_key false
  schema "submissions" do
    field :all, :integer
    field :done, :integer
    field :left, :integer

    belongs_to :participation, Participation
    belongs_to :tour, Tour
  end
end
