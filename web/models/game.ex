defmodule PickleballLeague.Game do
  use PickleballLeague.Web, :model

  schema "games" do
    has_many :scores, PickleballLeague.Score
    has_many :earned_points_ratios, PickleballLeague.EarnedPointsRatio

    has_many :teams, through: [:scores, :team]
    has_many :rosters, through: [:teams, :rosters]
    has_many :players, through: [:rosters, :player]
    timestamps
  end

  @required_fields ~w(scores)
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
