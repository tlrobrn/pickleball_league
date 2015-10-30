defmodule PickleballLeague.Group do
  use PickleballLeague.Web, :model

  schema "groups" do
    field :name, :string

    has_many :games, PickleballLeague.Game
    has_many :player_groups, PickleballLeague.PlayerGroup

    has_many :players, through: [:player_groups, :player]
    timestamps
  end

  @required_fields ~w(name)
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
