defmodule PickleballLeague.Roster do
  use PickleballLeague.Web, :model

  schema "rosters" do
    belongs_to :team, PickleballLeague.Team
    belongs_to :player, PickleballLeague.Player

    timestamps
  end

  @required_fields ~w(team_id player_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
