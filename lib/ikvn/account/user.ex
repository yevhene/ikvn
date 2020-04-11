defmodule Ikvn.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ikvn.Utils.Validation
  alias Ikvn.Account.{Link, User}
  alias Ikvn.Game.Participation

  schema "users" do
    field :nickname, :string
    field :email, :string
    field :name, :string
    field :permissions, {:array, :string}

    has_many :links, Link
    has_many :participations, Participation

    timestamps(type: :utc_datetime)
  end

  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name])
  end

  def profile_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:nickname, :email, :name])
    |> trim([:nickname, :email])
    |> validate_required([:nickname, :email])
    |> validate_format(:email, ~r/@/)
    |> forbid_change(:nickname)
    |> unique_constraint(:nickname)
  end
end
