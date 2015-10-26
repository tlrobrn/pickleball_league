defmodule PickleballLeague.Repo.Migrations.CreatePlayerGroup do
  use Ecto.Migration

  def change do
    create table(:player_groups) do
      add :player_id, references(:players)
      add :group_id, references(:groups)

      timestamps
    end
    create index(:player_groups, [:player_id])
    create index(:player_groups, [:group_id])

  end
end
