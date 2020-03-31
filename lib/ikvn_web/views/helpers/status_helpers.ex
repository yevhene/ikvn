defmodule IkvnWeb.StatusHelpers do
  import Phoenix.HTML.Tag
  import IkvnWeb.Gettext

  alias Ikvn.Game
  alias Ikvn.Game.Tour
  alias Ikvn.Game.Tournament

  def status(%Tournament{} = tournament) do
    cond do
      Game.is_future?(tournament) ->
        content_tag(:div, gettext("future"), class: "text-danger")
      Game.is_active?(tournament) ->
        content_tag(:div, gettext("started"), class: "text-success")
      Game.is_finished?(tournament) ->
        content_tag(:div, gettext("finished"), class: "text-secondary")
    end
  end

  def status(%Tour{} = tour) do
    cond do
      Game.is_future?(tour) ->
        content_tag(:div, gettext("future"), class: "text-danger")
      Game.is_active?(tour) ->
        content_tag(:div, gettext("started"), class: "text-success")
      Game.is_judging?(tour) ->
        content_tag(:div, gettext("judging"), class: "text-warning")
      Game.is_closed?(tour) ->
        content_tag(:div, gettext("finished"), class: "text-seconary")
    end
  end
end
