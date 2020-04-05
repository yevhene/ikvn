defmodule IkvnWeb.Judge.TaskView do
  use IkvnWeb, :view

  import IkvnWeb.MarkdownHelpers

  alias Ikvn.Game
  alias Ikvn.Game.Task

  def title(%Task{title: title}) do
    title || gettext("Task")
  end

  def not_judged_badge(%Task{} = task) do
    duty = Enum.at(task.duties, 0)
    if duty != nil and duty.left > 0 do
      not_judged_badge(duty.left)
    end
  end

  def not_judged_badge(solutions) when is_list(solutions) do
    Enum.count(solutions, fn solution -> Enum.empty?(solution.marks) end)
    |> not_judged_badge()
  end

  def not_judged_badge(count) do
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
