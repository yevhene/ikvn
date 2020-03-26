defmodule Ikvn.Repo do
  use Ecto.Repo,
    otp_app: :ikvn,
    adapter: Ecto.Adapters.Postgres
end
