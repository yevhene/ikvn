defmodule IkvnWeb.AuthController do
  use IkvnWeb, :controller

  require Logger

  import IkvnWeb.Guardian.Plug, only: [sign_in: 2]

  alias Ikvn.Account

  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, params) do
    Logger.error inspect(failure)

    conn
    |> put_flash(:error, gettext "Failed to authenticate")
    |> redirect(to: params["state"] || "/")
  end

  def callback(%{assigns: %{ueberauth_auth: oauth}} = conn, params) do
    case Account.authenticate(oauth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext "Successfully authenticated")
        |> sign_in(user)
        |> redirect(to: params["state"] || "/")
      {:error, reason} ->
        conn
        |> put_flash(
          :error,
          gettext("Error: %{reason}", reason: reason)
        )
        |> redirect(to: params["state"] || "/")
    end
  end
end
