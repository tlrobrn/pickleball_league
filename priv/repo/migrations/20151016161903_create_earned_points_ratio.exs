defmodule PickleballLeague.Repo.Migrations.CreateEarnedPointsRatio do
  use Ecto.Migration

  def change do
    create table(:earned_points_ratios) do
      add :value, :float
      add :player_id, references(:players)
      add :game_id, references(:games)

      timestamps
    end
    create index(:earned_points_ratios, [:player_id])
    create index(:earned_points_ratios, [:game_id])

  end
end
