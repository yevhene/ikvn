defmodule IkvnWeb.PageController do
  use IkvnWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
