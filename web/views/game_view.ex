defmodule PickleballLeague.GameView do
  use PickleballLeague.Web, :view
  alias PickleballLeague.Score
  alias PickleballLeague.Team

  def column_class(game) do
    "col-xs-#{div(12, length(game.teams))}"
  end

  def order(list) do
    list |> Enum.sort(&sort/2)
  end

  defp sort(a = %Score{}, b = %Score{}), do: a.team_id < b.team_id
  defp sort(a = %Team{}, b = %Team{}), do: a.id < b.id

  def display_player(player) do
    first_initial = String.first(player.first_name)
    "#{first_initial}. #{player.last_name}"
  end
end
