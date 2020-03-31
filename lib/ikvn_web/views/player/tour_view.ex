defmodule IkvnWeb.Player.TourView do
  use IkvnWeb, :view

  import IkvnWeb.MarkdownHelpers
  import IkvnWeb.DateTimeHelpers
  import IkvnWeb.StatusHelpers

  alias Ikvn.Game
  alias Ikvn.Game.Tour

  def title(%Tour{title: title}) do
    title || gettext("Tour")
  end
end
