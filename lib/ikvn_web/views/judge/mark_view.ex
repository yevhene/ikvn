defmodule IkvnWeb.Judge.MarkView do
  use IkvnWeb, :view
  import IkvnWeb.Helpers.Form
  alias Ikvn.Game
  alias Ikvn.Game.Mark

  def mark_form_class(mark, current_value) do
    if mark == nil || mark.value != current_value do
      "btn btn-outline-primary p-0"
    else
      "btn btn-primary p-0"
    end
  end

  def mark_button_class(mark, current_value) do
    if mark == nil || mark.value != current_value do
      "btn btn-outline-primary border-0"
    else
      "btn btn-primary border-0"
    end
  end

  def mark_static_class(mark, current_value) do
    if mark == nil || mark.value != current_value do
      "btn btn-outline-primary disabled"
    else
      "btn btn-primary disabled"
    end
  end

  def mark_range do
    (Mark.min())..(Mark.max())
  end
end
