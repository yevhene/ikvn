defmodule Ikvn.Account.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ikvn.Account.{Link, User}

  schema "links" do
    field :uid, :string
    field :provider, :string
    field :data, :map

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  def create_changeset(%Link{} = link, attrs) do
    link
    |> cast(attrs, [:uid, :provider, :user_id])
    |> validate_required([:uid, :provider, :user_id])
    |> unique_constraint(:uid, name: :links_uid_provider_index)
    |> foreign_key_constraint(:user_id)
  end

  def data_changeset(%Link{} = link, attrs) do
    link
    |> cast(attrs, [:data])
    |> validate_required([:data])
  end
end
