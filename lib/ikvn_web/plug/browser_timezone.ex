defmodule IkvnWeb.Plug.BrowserTimezone do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    browser_timezone = conn.req_cookies["browser_timezone"] || opts[:default]

    assign(conn, :browser_timezone, browser_timezone)
  end
end
