defmodule IkvnWeb.LayoutView do
  use IkvnWeb, :view

  def nickname(user) do
    user.nickname || gettext "Please set your nickname"
  end
end
