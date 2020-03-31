defmodule IkvnWeb.PageController do
  use IkvnWeb, :controller

  plug :put_layout, false

  def terms(conn, _params) do
    render(conn, "terms.html")
  end
end
