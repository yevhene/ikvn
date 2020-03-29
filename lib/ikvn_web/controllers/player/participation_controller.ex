defmodule IkvnWeb.Player.ParticipationController do
  use IkvnWeb, :controller

  alias Ikvn.Game

  def create(conn, _params) do
    case Game.create_participation(participation_params(conn)) do
      {:ok, _participation} ->
        conn
        |> put_flash(:info, gettext "You can now participate")
      {:error, _} ->
        conn
        |> put_flash(:error, gettext "Participation failed. Contact Admin")
    end
    |> redirect(to:
      Routes.tournament_path(conn, :show, conn.assigns.tournament)
    )
  end

  defp participation_params(conn) do
    %{
      "user_id" => conn.assigns.current_user.id,
      "creator_id" => conn.assigns.current_user.id,
      "tournament_id" => conn.assigns.tournament.id
    }
  end
end
