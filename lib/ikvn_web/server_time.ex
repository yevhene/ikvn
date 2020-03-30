defmodule IkvnWeb.ServerTime do
  def from_utc(%DateTime{} = datetime) do
    datetime
    |> DateTime.shift_zone!(default_timezone())
  end
  def from_utc(nil), do: nil

  def to_utc(%NaiveDateTime{} = naive) do
    {:ok, datetime} = DateTime.from_naive(naive, default_timezone())
    DateTime.shift_zone!(datetime, "Etc/UTC")
  end
  def to_utc(nil), do: nil

  def cast_datetime_params(params, fields) do
    Enum.reduce(fields, params, fn field, params ->
      cast_datetime_param(params, field)
    end)
  end

  def cast_datetime_param(params, field) do
    naive = cast_datetime_map(Map.get(params, field))
    Map.put(params, field, to_utc(naive))
  end

  defp cast_datetime_map(map) do
    {:ok, %Date{} = date} = cast_date(map)
    {:ok, %Time{} = time} = cast_time(map)
    {:ok, %NaiveDateTime{} = naive} = NaiveDateTime.new(date, time)
    naive
  end

  defp cast_date(%{"year" => year, "month" => month, "day" => day}) do
    Date.new(to_i(year), to_i(month), to_i(day))
  end

  defp cast_time(%{"hour" => hour, "minute" => minute}) do
    Time.new(to_i(hour), to_i(minute), 0)
  end

  defp to_i(nil), do: nil
  defp to_i(int) when is_integer(int), do: int
  defp to_i(bin) when is_binary(bin) do
    case Integer.parse(bin) do
      {int, ""} -> int
      _ -> nil
    end
  end

  defp default_timezone do
    Application.get_env(:ikvn, IkvnWeb.ServerTime)[:default_timezone]
  end
end
