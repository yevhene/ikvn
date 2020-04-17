defmodule Ikvn.Utils.MapUtils do
  def map_from_struct(%_{} = struct) do
    struct
    |> Map.from_struct()
    |> map_from_struct()
  end

  def map_from_struct(%{} = map) do
    map
    |> Map.keys()
    |> Enum.reduce(%{}, fn key, acc ->
      Map.put(acc, key, map_from_struct(Map.get(map, key)))
    end)
  end

  def map_from_struct(value), do: value

  def dig(%{} = map, [key | rest]) do
    value = Map.get(map, key)

    if rest != [] && is_map(value) do
      dig(value, rest)
    else
      value
    end
  end
end
