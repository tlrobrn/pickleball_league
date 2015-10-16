defmodule PickleballLeague.Repo.Migrations.CreateScore do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :points, :integer
      add :game_id, references(:games)
      add :team_id, references(:teams)

      timestamps
    end
    create index(:scores, [:game_id])
    create index(:scores, [:team_id])

  end
end
