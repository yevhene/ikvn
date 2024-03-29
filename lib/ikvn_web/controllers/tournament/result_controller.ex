defmodule IkvnWeb.Tournament.ResultController do
  use IkvnWeb, :controller
  alias Ikvn.Metrics

  def show(conn, _params) do
    {results, tours} = Metrics.list_results(conn.assigns.tournament)

    conn
    |> render("show.html", results: results, tours: tours)
  end
end
