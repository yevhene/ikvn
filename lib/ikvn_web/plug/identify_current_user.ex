defmodule IkvnWeb.Plug.IdentifyCurrentUser do
  import IkvnWeb.Gettext
  import Phoenix.Controller
  import Plug.Conn
  alias IkvnWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = conn.assigns.current_user
    if user_should_fill_profile?(current_user) do
      conn |> error_response
    else
      conn
    end
  end

  defp error_response(conn) do
    case get_format(conn) do
      "html" ->
        conn
        |> clear_flash()
        |> put_flash(:info, gettext "Please fill your profile")
        |> redirect(to: Routes.profile_path(conn, :edit))
        |> halt()
      _ ->
        conn
        |> send_resp(403, "")
        |> halt()
    end
  end

  defp user_should_fill_profile?(user) do
    user && (!user.nickname)
  end
end
