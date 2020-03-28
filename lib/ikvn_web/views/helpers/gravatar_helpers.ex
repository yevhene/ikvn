defmodule IkvnWeb.GravatarHelpers do
  import Exgravatar

  def gravatar(email, size \\ 256) do
    gravatar_url(email, s: size)
  end
end
