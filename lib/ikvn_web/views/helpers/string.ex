defmodule IkvnWeb.Helpers.String do
  def truncate(stringt, opts \\ []) do
    truncate_at = opts[:truncate_at] || 255
    separator = opts[:separator] || " "
    omission = opts[:omission] || "..."

    cond do
      not String.valid?(stringt) ->
        stringt

      String.length(stringt) < truncate_at ->
        stringt

      true ->
        total_length = truncate_at - String.length(omission)

        [String.slice(stringt, 0, total_length), omission]
        |> Enum.join(separator)
    end
  end

  def present?(string) do
    string && String.trim(string) != ""
  end

  def blank?(string) do
    !present?(string)
  end

  def coalesce(string, default) do
    if present?(string) do
      string
    else
      default
    end
  end
end
