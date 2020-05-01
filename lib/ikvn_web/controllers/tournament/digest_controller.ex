defmodule IkvnWeb.Tournament.DigestController do
  use IkvnWeb, :controller
  alias Ikvn.Metrics

  plug :load_tournament

  def show(conn, _params) do
    digest = Metrics.get_digest(conn.assigns.tournament)

    conn
    |> render("show.html", digest: digest)
  end
end
