defmodule Ikvn.Game.Role do
  use EctoEnum.Postgres, type: :role, enums: [:admin, :judge, :player, :ban]
end
