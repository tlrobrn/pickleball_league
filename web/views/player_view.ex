defmodule PickleballLeague.PlayerView do
  use PickleballLeague.Web, :view

  @no_games_value -1.0

  def sorted_players_with_eprs(players, opponent_eprs) do
    players
    |> Enum.sort_by(&length(&1.earned_points_ratios), &>=/2)
    |> Enum.sort_by(&String.to_float(opponent_eprs[&1]), &>=/2)
    |> Enum.map(&({&1, calculate_epr(&1)}))
    |> Enum.sort_by(fn {_p, epr} -> epr end, &>=/2)
  end

  def format_epr(@no_games_value), do: "-----"
  def format_epr(nil), do: "-----"
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
