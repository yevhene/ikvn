defmodule Ikvn.Game.Role do
  use EctoEnum.Postgres, type: :role, enums: [:player, :judge, :admin]
end
