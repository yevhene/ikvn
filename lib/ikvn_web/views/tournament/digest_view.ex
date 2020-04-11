defmodule IkvnWeb.Tournament.DigestView do
  use IkvnWeb, :view
  import IkvnWeb.Helpers.Markdown
  alias Ikvn.Game.{Task, Tour}

  def title(%Tour{title: title}) do
    title || gettext("Tour")
  end

  def title(%Task{title: title}) do
    title || gettext("Task")
  end
end
