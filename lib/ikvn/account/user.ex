defmodule Ikvn.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ikvn.Utils.Validation

  alias Ikvn.Account.Link
  alias Ikvn.Account.User

  schema "users" do
    field :nickname, :string
    field :is_admin, :boolean

    has_many :links, Link

    timestamps(type: :utc_datetime)
  end

  def profile_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:nickname])
    |> validate_required([:nickname])
    |> forbid_change(:nickname)
    |> unique_constraint(:nickname)
  end
end
