defmodule IkvnWeb.Plug.LoadTournament do
  import Phoenix.Controller
  import Plug.Conn

  alias Ikvn.Game

  def init(opts), do: opts

  def call(conn, _opts) do
    user = conn.assigns.current_user
    tournament = Game.get_tournament(tournament_id(conn))
    participation = Game.get_user_participation(user, tournament)

    if Game.tournament_is_available?(tournament, participation) do
      conn
      |> assign(:tournament, tournament)
      |> assign(:participation, participation)
    else
      conn
      |> error_response()
    end
  end

  defp tournament_id(conn) do
    conn.params["tournament_id"] || conn.params["id"]
  end

  defp error_response(conn) do
    format = conn.private.phoenix_format

    case format do
      "html" ->
        conn
        |> put_status(:not_found)
        |> put_view(IkvnWeb.ErrorView)
        |> render("404.html")
        |> halt()
      _ ->
        conn
        |> send_resp(404, "")
        |> halt()
    end
  end
end
