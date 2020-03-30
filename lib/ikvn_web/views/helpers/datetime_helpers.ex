defmodule IkvnWeb.DateTimeHelpers do
  alias Phoenix.HTML.Form
  import IkvnWeb.ServerTime

  def datetime(%DateTime{} = dt) do
    dt
    |> from_utc()
    |> format_datetime()
  end

  def server_datetime_select(form, field, opts \\ []) do
    value = Map.get(form.source.changes, field) || Map.get(form.data, field)
    value = case value do
      nil -> Map.get(form.params, to_string(field))
      value -> from_utc(value)
    end
    Form.datetime_select(form, field, Keyword.merge([value: value], opts))
  end

  defp format_datetime(%DateTime{
    year: year, month: month, day: day, hour: hour, minute: minute
  }) do
    "#{format(year)}-#{format(month)}-#{format(day)} " <>
    "#{format(hour)}:#{format(minute)}"
  end

  defp format(number) when number < 10, do: "0#{number}"
  defp format(number), do: "#{number}"
end
