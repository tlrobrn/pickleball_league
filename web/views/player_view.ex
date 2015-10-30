defmodule PickleballLeague.PlayerView do
  use PickleballLeague.Web, :view

  @no_games_value -1.0

  def sorted_players_with_eprs(players, opponent_eprs, false) do
    players
    |> Enum.sort_by(&length(&1.earned_points_ratios), &>=/2)
    |> Enum.sort_by(&(opponent_eprs[&1.id]), &>=/2)
    |> Enum.map(&({&1, calculate_epr(&1)}))
    |> Enum.sort_by(fn {_p, epr} -> epr end, &>=/2)
  end
  def sorted_players_with_eprs(players, opponent_eprs, group_id) do
    players
    |> Enum.sort_by(&length(&1.earned_points_ratios), &>=/2)
    |> Enum.sort_by(&(opponent_eprs[&1.id][group_id]), &>=/2)
    |> Enum.map(&({&1, calculate_epr(&1, group_id)}))
    |> Enum.sort_by(fn {_p, epr} -> epr end, &>=/2)
  end

  def display_player(player, true) do
    first_initial = String.first(player.first_name)
    "#{first_initial}. #{player.last_name}"
  end
  def display_player(player, false) do
    "#{player.first_name} #{player.last_name}"
  end

  def games_played(player, false) do
    length(player.earned_points_ratios)
  end
  def games_played(player, group_id) do
    player.earned_points_ratios
    |> Enum.count(&(&1.game.group_id == group_id))
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
  defp calculate_epr(player, group_id) do
    player.earned_points_ratios
    |> Enum.reduce({0, 0}, fn (epr, {earned, total}) ->
      case epr.game.group_id do
        ^group_id -> {earned + epr.earned_points, total + epr.total_points}
        _ -> {earned, total}
      end
    end)
    |> case do
      {_, 0} -> @no_games_value
      {earned_points, total_points} -> earned_points / total_points
    end
  end
end
