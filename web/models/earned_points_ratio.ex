defmodule PickleballLeague.EarnedPointsRatio do
  use PickleballLeague.Web, :model

  schema "earned_points_ratios" do
    field :value, :float
    belongs_to :player, PickleballLeague.Player
    belongs_to :game, PickleballLeague.Game

    timestamps
  end

  @required_fields ~w(value)
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
