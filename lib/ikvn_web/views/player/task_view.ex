defmodule IkvnWeb.Player.TaskView do
  use IkvnWeb, :view

  import IkvnWeb.MarkdownHelpers

  alias Ikvn.Game.Task

  def title(%Task{title: title}) do
    title || gettext("Task")
  end
end
