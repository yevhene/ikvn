defmodule Ikvn.Account.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ikvn.Account.Link
  alias Ikvn.Account.User

  schema "links" do
    field :uid, :string
    field :data, :map

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  def create_changeset(%Link{} = link, attrs) do
    link
    |> cast(attrs, [:uid, :user_id])
    |> validate_required([:uid, :user_id])
    |> unique_constraint(:uid)
    |> foreign_key_constraint(:user_id)
  end

  def data_changeset(%Link{} = link, attrs) do
    link
    |> cast(attrs, [:data])
    |> validate_required([:data])
  end
end
