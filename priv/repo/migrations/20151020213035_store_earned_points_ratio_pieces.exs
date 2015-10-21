defmodule PickleballLeague.Repo.Migrations.StoreEarnedPointsRatioPieces do
  use Ecto.Migration

  def change do
    alter table(:earned_points_ratios) do
      add :earned_points, :integer
      add :total_points, :integer
      remove :value
    end
  end
end
