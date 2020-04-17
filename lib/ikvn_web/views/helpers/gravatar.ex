defmodule IkvnWeb.Helpers.Gravatar do
  import Exgravatar

  def gravatar(email, opts \\ [])
  def gravatar(nil, opts), do: gravatar("user@example.com", opts)

  def gravatar(email, opts) do
    gravatar_url(email, Keyword.put(opts, :default, "wavatar"))
  end
end
