defmodule IkvnWeb.Plug.CheckCanSubmitMark do
  import IkvnWeb.Gettext
  import Phoenix.Controller
  import Plug.Conn
  alias Ikvn.Game
  alias IkvnWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if Game.tour_is_judging?(conn.assigns.tour) do
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
        |> put_flash(:error, gettext("Judging is finished"))
        |> redirect(
          to:
            Routes.judge_tournament_tour_path(
              conn,
              :show,
              conn.assigns.tournament,
              conn.assigns.tour
            )
        )
        |> halt()

      _ ->
        conn
        |> send_resp(:forbidden, "")
        |> halt()
    end
  end
end
