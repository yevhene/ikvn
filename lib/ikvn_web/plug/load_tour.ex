defmodule IkvnWeb.Plug.LoadTour do
  import Plug.Conn
  import IkvnWeb.Helpers.Error, only: [error_response: 2]
  alias Ikvn.Game

  def init(opts), do: opts

  def call(conn, _opts) do
    tour = Game.get_tour(tour_id(conn))

    if Game.tour_is_available?(tour, conn.assigns.current_role) do
      conn
      |> assign(:tour, tour)
    else
      conn
      |> error_response(:not_found)
      |> halt
    end
  end

  defp tour_id(conn) do
    conn.params["tour_id"] || conn.params["id"]
  end
end
