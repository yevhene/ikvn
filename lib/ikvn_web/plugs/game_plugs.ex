defmodule IkvnWeb.GamePlugs do
  use Phoenix.Router
  import Plug.Conn
  import IkvnWeb.Helpers.Error, only: [error_response: 2]
  import IkvnWeb.AuthPlugs, only: [check_permission: 2]
  alias Ikvn.Game

  pipeline :admin do
    plug :load_tournament
    plug :authorize, role: :admin
    plug :put_layout, {IkvnWeb.LayoutView, "admin.html"}
  end

  pipeline :judge do
    plug :load_tournament
    plug :authorize, role: :judge, for: [:admin, :judge]
    plug :put_layout, {IkvnWeb.LayoutView, "judge.html"}
  end

  pipeline :player do
    plug :load_tournament
    plug :authorize, role: :player
    plug :put_layout, {IkvnWeb.LayoutView, "player.html"}
  end

  pipeline :can_create_tournament do
    plug :check_permission, to: :create_tournament
  end

  def load(conn, opts) do
    Enum.reduce(opts[:resources], conn, fn resource, conn ->
      method = :erlang.binary_to_existing_atom("load_#{resource}", :utf8)
      apply(__MODULE__, method, [conn, nil])
    end)
  end

  def load_tournament(conn, _opts) do
    tournament =
      Game.get_tournament!(conn.params["tournament_id"] || conn.params["id"])

    user = conn.assigns.current_user
    participation = Game.get_user_participation(user, tournament)

    if Game.tournament_is_available?(tournament, participation) do
      conn
      |> assign(:tournament, tournament)
      |> assign(:participation, participation)
    else
      conn
      |> error_response(:not_found)
      |> halt
    end
  end

  def load_tour(conn, _opts) do
    tour = Game.get_tour!(conn.params["tour_id"] || conn.params["id"])

    if Game.tour_is_available?(tour, conn.assigns.current_role) do
      conn
      |> assign(:tour, tour)
    else
      conn
      |> error_response(:not_found)
      |> halt
    end
  end

  def load_task(conn, _opts) do
    task = Game.get_task!(conn.params["task_id"] || conn.params["id"])
    assign(conn, :task, task)
  end

  def load_solution(conn, _opts) do
    solution =
      Game.get_solution!(conn.params["solution_id"] || conn.params["id"])

    assign(conn, :solution, solution)
  end

  def authorize(conn, opts) do
    if is_accessible?(conn, opts) do
      conn |> assign(:current_role, opts[:role])
    else
      conn |> error_response(:forbidden)
    end
  end

  defp is_accessible?(conn, opts) do
    accessible_by = opts[:for] || [opts[:role]]
    participation = conn.assigns.participation
    Enum.member?(accessible_by, participation.role)
  end
end
