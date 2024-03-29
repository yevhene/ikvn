defmodule IkvnWeb.TournamentView do
  use IkvnWeb, :view
  import IkvnWeb.Helpers.{Markdown, String, Form, Navigation}
  import IkvnWeb.Permissions
  alias Ikvn.Game
  alias Ikvn.Game.Tournament

  def tournament_style(%Tournament{} = tournament) do
    if Game.tournament_is_active?(tournament) do
      "border-primary"
    else
      ""
    end
  end
end
