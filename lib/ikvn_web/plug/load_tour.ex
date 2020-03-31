defmodule IkvnWeb.Plug.LoadTour do
  import Phoenix.Controller
  import Plug.Conn

  alias Ikvn.Game

  def init(opts), do: opts

  def call(conn, _opts) do
    participation = conn.assigns.participation
    tour = Game.get_tour(tour_id(conn))

    if (
      tour == nil or (
        Game.tour_is_future?(tour) and (
          participation == nil or
          not Enum.member?([:admin, :judge], participation.role)
        )
      )
    ) do
      conn
      |> error_response()
    else
      conn
      |> assign(:tour, tour)
    end
  end

  defp tour_id(conn) do
    conn.params["tour_id"] || conn.params["id"]
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
