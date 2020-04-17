defmodule IkvnWeb.Tournament.ResultView do
  use IkvnWeb, :view

  def render_results_table_head(tours) do
    [
      table_head_top_row(tours),
      table_head_bottom_row(tours)
    ]
  end

  defp table_head_top_row(tours) do
    content_tag(:tr) do
      Enum.concat([
        [
          content_tag(:th, ""),
          content_tag(:th, "")
        ],
        tours_cells(tours),
        [
          content_tag(:th, raw("&Sigma;"), class: "table-danger", rowspan: 2)
        ]
      ])
    end
  end

  defp tours_cells(tours) do
    Enum.map(tours, fn tour ->
      content_tag(:th, tour.title, colspan: Enum.count(tour.tasks) + 1)
    end)
  end

  defp table_head_bottom_row(tours) do
    content_tag(:tr) do
      Enum.concat([
        [
          content_tag(:th, "#"),
          content_tag(:th, gettext("Nickname"))
        ],
        tasks_cells(tours)
      ])
    end
  end

  defp tasks_cells(tours) do
    tours
    |> Enum.map(&Enum.with_index(&1.tasks, 1))
    |> Enum.flat_map(fn tasks ->
      Enum.concat([
        Enum.map(tasks, fn {_, index} ->
          content_tag(:th, index)
        end),
        [
          content_tag(:th, raw("&Sigma;"), class: "table-warning")
        ]
      ])
    end)
  end

  def render_results_table_row(result) do
    content_tag(:tr) do
      Enum.concat([
        [
          content_tag(:td, result.place),
          content_tag(:td, result.nickname)
        ],
        result_cells(result),
        [
          content_tag(:th, float_to_string(result.total), class: "table-danger")
        ]
      ])
    end
  end

  defp result_cells(result) do
    Enum.flat_map(result.tours, fn tour ->
      Enum.concat([
        Enum.map(tour.tasks, fn task ->
          content_tag(:td, float_to_string(task))
        end),
        [
          content_tag(:th, float_to_string(tour.total), class: "table-warning")
        ]
      ])
    end)
  end

  defp float_to_string(float), do: :erlang.float_to_binary(float, decimals: 1)
end
