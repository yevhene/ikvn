defmodule Ikvn.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ikvn.Utils.Validation

  alias Ikvn.Account.Link
  alias Ikvn.Account.User
  alias Ikvn.Game.Participation

  schema "users" do
    field :nickname, :string
    field :email, :string
    field :permissions, {:array, :string}

    has_many :links, Link
    has_many :participations, Participation

    timestamps(type: :utc_datetime)
  end

  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
  end

  def profile_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:nickname, :email])
    |> validate_required([:nickname, :email])
    |> forbid_change(:nickname)
    |> unique_constraint(:nickname)
  end
end
