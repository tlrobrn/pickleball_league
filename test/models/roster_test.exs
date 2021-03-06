defmodule PickleballLeague.RosterTest do
  use PickleballLeague.ModelCase

  alias PickleballLeague.Roster

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Roster.changeset(%Roster{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Roster.changeset(%Roster{}, @invalid_attrs)
    refute changeset.valid?
  end
end
