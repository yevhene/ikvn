defmodule Ikvn.Account do
  import Ecto.Query, warn: false
  import IkvnWeb.Gettext

  require Logger

  alias Ikvn.Account.Link
  alias Ikvn.Account.User
  alias Ikvn.Repo
  alias Ikvn.Utils.MapUtils

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
    data = auth |> MapUtils.map_from_struct()

    with {:ok, user, link} <- user_from_auth(auth),
         {:ok, _link} <- update_link_data(link, data)
    do
      {:ok, user}
    else
      _ -> {:error, gettext("Authentication failed")}
    end
  end

  defp create_user(attrs) do
    %User{}
    |> User.create_changeset(attrs)
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

  defp user_from_auth(%{uid: uid, provider: provider, extra: extra}) do
    case  Link |> Repo.get_by(uid: uid) |> Repo.preload(:user) do
      %Link{} = link -> {:ok, link.user, link}
      _ ->
        try do
          email = extra |> MapUtils.dig([:raw_info, :user, "email"])
          Repo.transaction(fn ->
            {:ok, user} = create_user(%{email: email})
            {:ok, link} = create_link(%{
               uid: uid, provider: to_string(provider), user_id: user.id
             })
            {:ok, user, link}
          end)
        rescue
          e ->
            Logger.error inspect(e)
            {:error, e}
        end
    end
  end
end
