defmodule PickleballLeague.PlayerView do
  use PickleballLeague.Web, :view

  @no_games_value -1.0

  def sorted_players_with_eprs(players) do
    players
    |> Enum.map(fn player -> {player, calculate_epr(player)} end)
    |> Enum.sort(fn ({_p1, epr1}, {_p2, epr2}) -> epr1 >= epr2 end)
  end

  def format_epr(@no_games_value), do: "-----"
  def format_epr(epr), do: Float.to_string(epr, decimals: 3)

  defp calculate_epr(player) do
    player.earned_points_ratios
    |> Enum.reduce({0, 0}, fn (epr, {earned, total}) ->
      {earned + epr.earned_points, total + epr.total_points}
    end)
    |> case do
      {_, 0} -> @no_games_value
      {earned_points, total_points} -> earned_points / total_points
    end
  end
end
