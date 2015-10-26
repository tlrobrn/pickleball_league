defmodule PickleballLeague.PlayerGroupTest do
  use PickleballLeague.ModelCase

  alias PickleballLeague.PlayerGroup

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PlayerGroup.changeset(%PlayerGroup{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PlayerGroup.changeset(%PlayerGroup{}, @invalid_attrs)
    refute changeset.valid?
  end
end
