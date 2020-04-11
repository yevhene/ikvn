defmodule IkvnWeb.Admin.TourView do
  use IkvnWeb, :view
  import IkvnWeb.Helpers.{Markdown, DateTime, Status}
  alias Ikvn.Game.Tour

  def title(%Tour{title: title}) do
    title || gettext("Tour")
  end
end
