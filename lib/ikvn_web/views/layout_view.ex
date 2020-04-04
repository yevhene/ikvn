defmodule IkvnWeb.LayoutView do
  use IkvnWeb, :view

  import IkvnWeb.GravatarHelpers

  def base_layout(assigns, do: content) do
    render "base.html", Map.put(assigns, :content, content)
  end

  def nav_item(conn, text, path, opts \\ []) do
    exact = Keyword.get(opts, :exact, false)
    content_tag :li, class: "nav-item" do
      link to: path, class: nav_item_link_class(conn, path, exact) do
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

  defp nav_item_link_class(conn, path, exact) do
    if nav_item_active?(path, conn.request_path, exact) do
      "nav-link active"
    else
      "nav-link"
    end
  end

  defp nav_item_active?(path, current_path, exact) do
    if exact do
      current_path =~ ~r{^#{path}(/\d+.*)?(/edit|/new)?$}
    else
      current_path =~ ~r{^#{path}.*$}
    end
  end

  def nickname(user) do
    user.nickname || gettext "Unknown"
  end
end
