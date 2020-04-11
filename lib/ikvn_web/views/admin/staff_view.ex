defmodule IkvnWeb.Admin.StaffView do
  use IkvnWeb, :view
  import IkvnWeb.Helpers.Badge
  alias Ikvn.Game.Participation

  def judged_badge(%Participation{duties: duties}) do
    duties
    |> Enum.map(&badge/1)
  end
end
