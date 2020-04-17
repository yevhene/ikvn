defmodule Ikvn.Utils.Validation do
  import IkvnWeb.Gettext
  import Ecto.Changeset

  def validate_datetime_after(changeset, field, after_field) do
    value = get_field(changeset, field)
    after_value = get_field(changeset, after_field)

    if DateTime.compare(value, after_value) == :lt do
      add_error(
        changeset,
        field,
        gettext("Must be consistent with other dates")
      )
    else
      changeset
    end
  end

  def forbid_change(changeset, field) do
    validate_change(changeset, field, fn current_field, _value ->
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
    Enum.reduce(fields, changeset, fn field, changeset ->
      trim(changeset, field)
    end)
  end

  def trim(changeset, field) when is_atom(field) do
    update_change(changeset, field, fn value ->
      if value == nil do
        value
      else
        String.trim(value)
      end
    end)
  end
end
