defmodule IkvnWeb.LayoutView do
  use IkvnWeb, :view
  import IkvnWeb.Helpers.{Gravatar, Navigation}

  def base_layout(assigns, do: content) do
    render "base.html", Map.put(assigns, :content, content)
  end

  def nickname(user) do
    user.nickname || gettext "Unknown"
  end
end
