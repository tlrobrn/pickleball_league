defmodule PickleballLeague.PageController do
  use PickleballLeague.Web, :controller
  alias PickleballLeague.Group
  alias PickleballLeague.PlayerController

  def index(conn, _params) do
    opponent_eprs = PlayerController.opponent_eprs_by_group
    groups = Group
    |> Repo.all
    |> Repo.preload(players: [earned_points_ratios: :game])

    render(conn, "index.html", groups: groups, opponent_eprs: opponent_eprs)
  end
end
