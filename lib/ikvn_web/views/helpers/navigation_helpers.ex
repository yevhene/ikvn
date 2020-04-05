defmodule IkvnWeb.NavigationHelpers do
  import Phoenix.HTML.Link
  import Phoenix.HTML.Tag
  import IkvnWeb.Gettext

  def nav_item(conn, text, path, opts \\ []) do
    content_tag :li, class: "nav-item" do
      link to: path, class: nav_item_link_class(conn, path) do
        if opts[:counter] do
          [
            content_tag(:span, "#{text} "),
            content_tag(:span, opts[:counter], class: "badge badge-primary"),
            content_tag(:span, gettext("New"), class: "sr-only")
          ]
        else
          content_tag(:span, text)
        end
      end
    end
  end

  defp nav_item_link_class(conn, path) do
    if nav_item_active?(path, conn.request_path) do
      "nav-link active"
    else
      "nav-link"
    end
  end

  defp nav_item_active?(path, current_path) do
    current_path =~ ~r{^#{path}(/\d+.*)?(/edit|/new)?$}
  end
end
