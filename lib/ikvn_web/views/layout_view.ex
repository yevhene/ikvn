defmodule IkvnWeb.LayoutView do
  use IkvnWeb, :view

  import Exgravatar

  def nickname(user) do
    user.nickname || gettext "Unknown"
  end

  def gravatar(email, size \\ 256) do
    gravatar_url(email, s: size)
  end
end
