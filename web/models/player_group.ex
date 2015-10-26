defmodule PickleballLeague.PlayerGroup do
  use PickleballLeague.Web, :model

  schema "player_groups" do
    belongs_to :player, PickleballLeague.Player
    belongs_to :group, PickleballLeague.Group

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
