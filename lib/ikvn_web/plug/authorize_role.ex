defmodule IkvnWeb.Plug.AuthorizeRole do
  import IkvnWeb.Gettext
  import Phoenix.Controller
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    if is_accessible?(conn, opts) do
      conn |> assign(:current_role, opts[:role])
    else
      conn |> error_response
    end
  end

  defp is_accessible?(conn, opts) do
    accessible_by = opts[:accessible_by] || [opts[:role]]
    participation = conn.assigns.participation
    Enum.member?(accessible_by, participation.role)
  end

  defp error_response(conn) do
    format = conn.private.phoenix_format

    case format do
      "html" ->
        conn
        |> put_flash(:error, gettext("You are not authrorized to do that"))
        |> redirect(to: "/")
        |> halt()

      _ ->
        conn
        |> send_resp(:forbidden, "")
        |> halt()
    end
  end
end
