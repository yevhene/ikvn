defmodule IkvnWeb.TournamentView do
  use IkvnWeb, :view

  import IkvnWeb.MarkdownHelpers
  import IkvnWeb.StringHelpers
  import IkvnWeb.Permissions
  import IkvnWeb.DateTimeHelpers
  import IkvnWeb.StatusHelpers

  alias Ikvn.Game
  alias Ikvn.Game.Tournament

  def tournament_style(%Tournament{} = tournament) do
    if Game.is_active?(tournament) do
      "border-primary"
    else
      ""
    end
  end
end
