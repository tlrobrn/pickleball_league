defmodule PickleballLeague.Score do
  use PickleballLeague.Web, :model

  schema "scores" do
    field :points, :integer
    belongs_to :game, PickleballLeague.Game
    belongs_to :team, PickleballLeague.Team

    timestamps
  end

  @required_fields ~w(points)
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
