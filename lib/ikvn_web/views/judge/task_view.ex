defmodule IkvnWeb.Judge.TaskView do
  use IkvnWeb, :view

  import IkvnWeb.MarkdownHelpers

  alias Ikvn.Game
  alias Ikvn.Game.Task

  def title(%Task{title: title}) do
    title || gettext("Task")
  end

  def not_judged_badge(solutions) do
    count = Enum.count(solutions, fn solution ->
      Enum.empty?(solution.marks)
    end)

    if count > 0 do
      content_tag :span, count, class: "badge badge-danger ml-1"
    end
  end

  def not_judged(solutions) do
    Enum.filter(solutions, fn solution -> Enum.empty?(solution.marks) end)
  end

  def judged(solutions) do
    Enum.filter(solutions, fn solution -> not Enum.empty?(solution.marks) end)
  end
end
