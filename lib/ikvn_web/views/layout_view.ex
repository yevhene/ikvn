defmodule IkvnWeb.LayoutView do
  use IkvnWeb, :view

  import IkvnWeb.GravatarHelpers
  import IkvnWeb.NavigationHelpers

  def base_layout(assigns, do: content) do
    render "base.html", Map.put(assigns, :content, content)
  end

  def nickname(user) do
    user.nickname || gettext "Unknown"
  end
end
