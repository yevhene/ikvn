defmodule IkvnWeb.Helpers.Markdown do
  import HtmlSanitizeEx
  import Earmark

  def markdown(nil), do: nil

  def markdown(text) do
    {:safe, sanitized_html(text)}
  end

  defp sanitized_html(text) do
    text
    |> as_html!
    |> markdown_html
  end
end
