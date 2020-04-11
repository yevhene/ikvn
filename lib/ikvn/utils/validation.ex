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

  def trim(changeset, fields) when is_list(fields) do
    Enum.reduce(fields, changeset, fn (field, changeset) ->
      trim(changeset, field)
    end)
  end

  def trim(changeset, field) when is_atom(field) do
    update_change(changeset, field, fn (value) ->
      if value == nil do
        value
      else
        String.trim(value)
      end
    end)
  end
end
