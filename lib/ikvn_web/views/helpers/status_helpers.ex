defmodule IkvnWeb.StatusHelpers do
  import Phoenix.HTML.Tag
  import IkvnWeb.Gettext

  alias Ikvn.Game
  alias Ikvn.Game.Tour

  def status(%Tour{} = tour) do
    cond do
      Game.tour_is_future?(tour) ->
        content_tag(:span, gettext("future"), class: "badge badge-danger")
      Game.tour_is_active?(tour) ->
        content_tag(:span, gettext("started"), class: "badge badge-success")
      Game.tour_is_judging?(tour) ->
        content_tag(:span, gettext("judging"), class: "badge badge-warning")
      Game.tour_is_closed?(tour) ->
        content_tag(:span, gettext("finished"), class: "badge badge-secondary")
    end
  end
end
