defmodule Ikvn.Account do
  import Ecto.Query, warn: false

  alias Ikvn.Repo
  alias Ikvn.Account.Link
  alias Ikvn.Account.User
  alias Ikvn.Utils

  def get_user!(id), do: Repo.get!(User, id)

  def change_user_profile(%User{} = user) do
    user
    |> User.profile_changeset(%{})
  end

  def update_user_profile(%User{} = user, attrs) do
    user
    |> User.profile_changeset(attrs)
    |> Repo.update()
  end

  def authenticate(%Ueberauth.Auth{} = auth) do
    data = auth |> Utils.map_from_struct()

    with {:ok, user, link} <- user_from_auth(auth),
         {:ok, _link} <- update_link_data(link, data)
    do
      {:ok, user}
    else
      _ -> {:error, "Can't authenticate"}
    end
  end

  defp create_user() do
    %User{}
    |> Repo.insert()
  end

  defp create_link(attrs) do
    %Link{}
    |> Link.create_changeset(attrs)
    |> Repo.insert()
  end

  defp update_link_data(link, data) do
    link
    |> Link.data_changeset(%{data: data})
    |> Repo.update()
  end

  defp user_from_auth(%{uid: uid}) do
    case  Link |> Repo.get_by(uid: uid) |> Repo.preload(:user) do
      %Link{} = link -> {:ok, link.user, link}
      _ ->
        with {:ok, user} = create_user(),
             {:ok, link} = create_link(%{uid: uid, user_id: user.id})
        do
          {:ok, user, link}
        end
    end
  end
end
