defmodule IkvnWeb.Plug.CheckRole do
  import IkvnWeb.Gettext
  import Phoenix.Controller
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    participation = conn.assigns.participation
    if participation.role == opts[:role] do
      conn
    else
      conn |> error_response
    end
  end

  defp error_response(conn) do
    format = conn.private.phoenix_format

    case format do
      "html" ->
        conn
        |> put_flash(:error, gettext "You are not authrorized to do that")
        |> redirect(to: "/")
        |> halt()
      _ ->
        conn
        |> send_resp(403, "")
        |> halt()
    end
  end
end
