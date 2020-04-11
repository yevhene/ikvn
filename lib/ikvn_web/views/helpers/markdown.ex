defmodule IkvnWeb.Helpers.Markdown do
  import Phoenix.HTML, only: [raw: 1]
  import Earmark

  def markdown(nil), do: nil

  def markdown(text) do
    text
    |> as_html!
    |> raw
  end
end
