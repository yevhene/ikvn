defmodule IkvnWeb.RenderHelpers do
  import Phoenix.View, only: [render: 3]

  def render_many_with_index(collection, view, template, assigns \\ %{}) do
    assigns = to_map(assigns)
    resource_name = get_resource_name(assigns, view)
    collection
    |> Enum.with_index()
    |> Enum.map(fn {resource, index} ->
      current_assigns = assigns
      |> Map.put(resource_name, resource)
      |> Map.put_new(:index, index)
      render(view, template, current_assigns)
    end)
  end

  defp to_map(assigns) when is_map(assigns), do: assigns
  defp to_map(assigns) when is_list(assigns), do: :maps.from_list(assigns)

  defp get_resource_name(assigns, view) do
    case assigns do
      %{as: as} -> as
      _ -> view.__resource__
    end
  end
end
