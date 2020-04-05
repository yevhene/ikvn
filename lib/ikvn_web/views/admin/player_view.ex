defmodule IkvnWeb.Admin.PlayerView do
  use IkvnWeb, :view

  import IkvnWeb.RenderHelpers
  import IkvnWeb.BadgeHelpers

  alias Ikvn.Game.Participation

  def submitted_badge(%Participation{submissions: submissions}) do
    submitted = Enum.at(submissions, 0)
    badge(submitted)
  end
end
