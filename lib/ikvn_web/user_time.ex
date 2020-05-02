defmodule IkvnWeb.UserTime do
  import Plug.Conn, only: [assign: 3]

  def browser_timezone(conn, opts) do
    browser_timezone = conn.req_cookies["browser_timezone"] || opts[:default]
    assign(conn, :browser_timezone, browser_timezone)
  end

  def from_utc(datetime, timezone)

  def from_utc(%DateTime{} = datetime, timezone) do
    DateTime.shift_zone!(datetime, timezone)
  end

  def from_utc(nil, _), do: nil

  def to_utc(naive, timezone)

  def to_utc(%NaiveDateTime{} = naive, timezone) do
    with {:ok, datetime} <- DateTime.from_naive(naive, timezone),
         result <- DateTime.shift_zone!(datetime, "Etc/UTC") do
      result
    else
      _ -> nil
    end
  end

  def to_utc(nil, _), do: nil

  def cast_datetime_params(params, fields, timezone) do
    Enum.reduce(fields, params, fn field, params ->
      cast_datetime_param(params, field, timezone)
    end)
  end

  def cast_datetime_param(params, field, timezone) do
    case cast_datetime_map(Map.get(params, field)) do
      {:ok, naive} -> Map.put(params, field, to_utc(naive, timezone))
      {:error, _error} -> params
    end
  end

  defp cast_datetime_map(map) do
    with {:ok, %Date{} = date} <- cast_date(map),
         {:ok, %Time{} = time} <- cast_time(map),
         {:ok, %NaiveDateTime{} = naive} <- NaiveDateTime.new(date, time) do
      {:ok, naive}
    else
      err -> {:error, err}
    end
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
end
