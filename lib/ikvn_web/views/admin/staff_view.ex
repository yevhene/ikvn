defmodule IkvnWeb.Admin.StaffView do
  use IkvnWeb, :view

  import IkvnWeb.BadgeHelpers

  alias Ikvn.Game.Participation

  def judged_badge(%Participation{duties: duties}) do
    duty = Enum.at(duties, 0)
    badge(duty)
  end
end
