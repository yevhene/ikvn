defmodule IkvnWeb.Judge.SolutionView do
  use IkvnWeb, :view

  import IkvnWeb.MarkdownHelpers

  alias Ikvn.Game

  def mark_button_class(mark, current_value) do
    if mark == nil || mark.value != current_value do
      "btn btn-outline-primary"
    else
      "btn btn-primary"
    end
  end
end
