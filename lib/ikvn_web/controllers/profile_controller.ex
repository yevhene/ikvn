defmodule IkvnWeb.ProfileController do
  use IkvnWeb, :controller
  alias Ikvn.Account

  def show(conn, _params) do
    user = conn.assigns.current_user
    render(conn, "show.html", user: user)
  end

  def edit(conn, _params) do
    user = conn.assigns.current_user
    changeset = Account.change_user_profile(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user
    case Account.update_user_profile(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext "Profile updated successfully")
        |> redirect(to: "/")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
