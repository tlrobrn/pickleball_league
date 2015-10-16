defmodule PickleballLeague.Repo.Migrations.CreateTeam do
  use Ecto.Migration

  def change do
    create table(:teams) do

      timestamps
    end

  end
end
