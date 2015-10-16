defmodule PickleballLeague.Team do
  use PickleballLeague.Web, :model

  schema "teams" do
    has_many :rosters, PickleballLeague.Roster
    has_many :scores, PickleballLeague.Score

    has_many :games, through: [:scores, :game]
    has_many :players, through: [:rosters, :player]
    timestamps
  end

  @required_fields ~w()
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
