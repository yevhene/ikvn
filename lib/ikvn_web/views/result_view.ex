defmodule IkvnWeb.ResultView do
  use IkvnWeb, :view

  import IkvnWeb.MarkdownHelpers

  alias Ikvn.Game.Task
  alias Ikvn.Game.Tour

  def title(%Tour{title: title}) do
    title || gettext("Tour")
  end

  def title(%Task{title: title}) do
    title || gettext("Task")
  end

  def render_results_table_head(tours) do
    [
      content_tag(:tr, [
        content_tag(:th, ""),
        content_tag(:th, "")
      ] ++ (
        Enum.map(tours, fn tour ->
          content_tag(:th, tour.title, colspan: Enum.count(tour.tasks) + 1)
        end)
      ) ++ [
        content_tag(:th, raw("&Sigma;"), class: "table-danger", rowspan: 2)
      ]),
      content_tag(:tr, [
        content_tag(:th, "#"),
        content_tag(:th, gettext "Nickname")
      ] ++ (
        tours
        |> Enum.map(&(Enum.with_index(&1.tasks, 1)))
        |> Enum.flat_map(fn tasks ->
          Enum.map(tasks, fn {_ , index} ->
            content_tag(:th, index)
          end) ++ [
            content_tag(:th, raw("&Sigma;"), class: "table-warning")
          ]
        end)
      ))
    ]
  end

  def render_results_table_row(result) do
    content_tag(:tr, do: [
      content_tag(:td, result.place),
      content_tag(:td, result.nickname)
    ] ++ (
      Enum.flat_map(result.tours, fn tour ->
        Enum.map(tour.tasks, fn task ->
          content_tag(:td, float_to_string(task))
        end) ++ [
          content_tag(:th, float_to_string(tour.total), class: "table-warning")
        ]
      end)
    ) ++ [
      content_tag(:th, float_to_string(result.total), class: "table-danger")
    ])
  end

  def float_to_string(float), do: :erlang.float_to_binary(float, [decimals: 1])
end
