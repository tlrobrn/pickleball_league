defmodule PickleballLeague.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :first_name, :string
      add :last_name, :string

      timestamps
    end

  end
end
