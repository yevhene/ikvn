defmodule IkvnWeb.Guardian.ErrorHandler do
  import IkvnWeb.Gettext
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Plug.Conn, only: [halt: 1, send_resp: 3]
  import IkvnWeb.Guardian.Plug, only: [sign_out: 1]

  def auth_error(conn, {_type, {_kind, reason}}, _opts) do
    format = conn.private.phoenix_format

    case format do
      "html" ->
        conn
        |> sign_out
        |> put_flash(
          :error,
          gettext("Authorization failed: %{reason}", reason: reason)
        )
        |> redirect(to: "/")
        |> halt()

      _ ->
        conn
        |> sign_out
        |> send_resp(403, "")
        |> halt()
    end
  end
end
