defmodule IkvnWeb.AuthView do
  use IkvnWeb, :view

  alias Plug.Conn.Query

  def facebook_url(conn) do
    params = Query.encode(%{state: conn.request_path})
    "/auth/facebook?#{params}"
  end
end
