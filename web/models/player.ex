defmodule PickleballLeague.Player do
  use PickleballLeague.Web, :model

  schema "players" do
    field :first_name, :string
    field :last_name, :string

    has_many :earned_points_ratios, PickleballLeague.EarnedPointsRatio
    has_many :rosters, PickleballLeague.Roster
    has_many :player_groups, PickleballLeague.PlayerGroup

    has_many :teams, through: [:rosters, :team]
    has_many :scores, through: [:teams, :score]
    has_many :games, through: [:teams, :game]
    has_many :groups, through: [:player_groups, :group]
    timestamps
  end

  @required_fields ~w(first_name last_name)
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
