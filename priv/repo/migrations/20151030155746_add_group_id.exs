defmodule PickleballLeague.Repo.Migrations.AddGroupId do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :group_id, references(:groups)
    end
  end
end
