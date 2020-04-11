defmodule IkvnWeb.Helpers.Badge do
  import Phoenix.HTML.Tag

  def badge(nil), do: ""

  def badge(%{done: done, all: all}) do
    case done do
      ^all ->
        content_tag :span, "#{done} / #{all}", class: "badge badge-success ml-1"
      0 ->
        content_tag :span, "#{done} / #{all}", class: "badge badge-danger ml-1"
      _ ->
        content_tag :span, "#{done} / #{all}", class: "badge badge-warning ml-1"
    end
  end
end
