defmodule PickleballLeague.Repo.Migrations.AddUniqueIndicesForEpr do
  use Ecto.Migration

  def change do
    create unique_index(:earned_points_ratios, [:player_id, :game_id])
  end
end
