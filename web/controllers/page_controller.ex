defmodule PickleballLeague.PageController do
  use PickleballLeague.Web, :controller
  alias PickleballLeague.Player
  alias PickleballLeague.PlayerController

  def index(conn, _params) do
    players = Repo.all(Player) |> Repo.preload(:earned_points_ratios)
    opponent_eprs = PlayerController.opponent_eprs
    groups = players
    |> Enum.chunk(4)
    |> Enum.with_index
    |> Enum.map(fn {players, name} -> %{players: players, name: name} end)

    render(conn, "index.html", groups: groups, opponent_eprs: opponent_eprs)
  end
end
