defmodule IkvnWeb.Admin.PlayerView do
  use IkvnWeb, :view
  import IkvnWeb.Helpers.{Badge, Render}
  alias Ikvn.Game.Participation

  def submitted_badge(%Participation{submissions: submissions}) do
    submissions
    |> Enum.map(&badge/1)
  end
end
