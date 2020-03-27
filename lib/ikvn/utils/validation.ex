defmodule Ikvn.Utils.Validation do
  import IkvnWeb.Gettext
  import Ecto.Changeset

  def forbid_change(changeset, field) when is_atom(field) do
    validate_change(changeset, field, fn (current_field, _value) ->
      with %{data: data} <- changeset,
           current_value <- Map.get(data, current_field) do
        if current_value != nil do
          [{current_field, gettext("You cannot change this field")}]
        else
          []
        end
      end
    end)
  end
end
