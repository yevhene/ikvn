defmodule IkvnWeb.SessionController do
  use IkvnWeb, :controller

  import IkvnWeb.Guardian.Plug, only: [sign_out: 1]

  def delete(conn, _params) do
    conn
    |> sign_out
    |> put_flash(:info, gettext "Signed out")
    |> redirect(to: "/")
  end
end
