defmodule IkvnWeb.Tournament.DigestView do
  use IkvnWeb, :view

  import IkvnWeb.MarkdownHelpers

  alias Ikvn.Game.Task
  alias Ikvn.Game.Tour

  def title(%Tour{title: title}) do
    title || gettext("Tour")
  end

  def title(%Task{title: title}) do
    title || gettext("Task")
  end
end
