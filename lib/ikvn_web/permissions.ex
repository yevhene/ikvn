defmodule IkvnWeb.Permissions do
  @doc """
  Possible permissions:
  - create_tournament
  """
  def can?(user, action) do
    if user != nil do
      Enum.member?(user.permissions, to_string(action)) || user.id == 1
    else
      false
    end
  end
end
