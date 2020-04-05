defmodule IkvnWeb.Player.ResultController do
  use IkvnWeb, :controller

  alias Ikvn.Metrics

  def show(conn, _params) do
    {results, tours} = Metrics.list_results(conn.assigns.tournament)
    digest = Metrics.get_digest(conn.assigns.tournament)
    conn
    |> put_view(IkvnWeb.ResultView)
    |> render("index.html", results: results, tours: tours, digest: digest)
  end
end
