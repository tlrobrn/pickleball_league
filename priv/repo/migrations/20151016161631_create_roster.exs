defmodule PickleballLeague.Repo.Migrations.CreateRoster do
  use Ecto.Migration

  def change do
    create table(:rosters) do
      add :team_id, references(:teams)
      add :player_id, references(:players)

      timestamps
    end
    create index(:rosters, [:team_id])
    create index(:rosters, [:player_id])

  end
end
