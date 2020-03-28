defmodule IkvnWeb.Plug.CheckPermission do
  import IkvnWeb.Gettext
  import Phoenix.Controller
  import Plug.Conn
  import IkvnWeb.Permissions

  def init(opts), do: opts

  def call(conn, opts) do
    if can?(conn.assigns.current_user, opts[:permission]) do
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
        |> put_flash(:error, gettext "You have no permission to do this")
        |> redirect(to: "/")
        |> halt()
      _ ->
        conn
        |> send_resp(403, "")
        |> halt()
    end
  end
end
