defmodule PickleballLeague.GameTest do
  use PickleballLeague.ModelCase

  alias PickleballLeague.Game

  @valid_attrs %{}
  @invalid_attrs %{scores: "not scores"}

  test "changeset with valid attributes" do
    changeset = Game.changeset(%Game{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Game.changeset(%Game{}, @invalid_attrs)
    refute changeset.valid?
  end
end
