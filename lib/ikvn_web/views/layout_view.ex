defmodule IkvnWeb.LayoutView do
  use IkvnWeb, :view

  import IkvnWeb.GravatarHelpers

  def base_layout(assigns, do: content) do
    render "base.html", Map.put(assigns, :content, content)
  end

  def nav_item(conn, text, path, counter \\ 0) do
    content_tag :li, class: "nav-item" do
      link to: path, class: nav_item_link_class(conn, path) do
        if counter == 0 do
          content_tag(:span, text)
        else
          [
            content_tag(:span, "#{text} "),
            content_tag(:span, counter, class: "badge badge-primary"),
            content_tag(:span, gettext("New"), class: "sr-only")
          ]
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
    current_path =~ ~r{#{path}(/edit|/new)?(/\d+.*)?$}
  end

  def nickname(user) do
    user.nickname || gettext "Unknown"
  end
end
