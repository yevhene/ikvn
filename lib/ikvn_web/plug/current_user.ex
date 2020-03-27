defmodule IkvnWeb.Plug.CurrentUser do
  import Guardian.Plug, only: [current_resource: 1]
  import Plug.Conn, only: [assign: 3]

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = current_resource(conn)
    assign(conn, :current_user, current_user)
  end
end
