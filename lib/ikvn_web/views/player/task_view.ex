defmodule IkvnWeb.Player.TaskView do
  use IkvnWeb, :view
  import IkvnWeb.Helpers.Markdown
  alias Ikvn.Game
  alias Ikvn.Game.Task

  def title(%Task{title: title}) do
    title || gettext("Task")
  end
end
