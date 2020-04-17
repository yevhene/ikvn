defmodule Ikvn.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  alias Ikvn.Game.Role

  def change do
    Role.create_type()
  end
end
