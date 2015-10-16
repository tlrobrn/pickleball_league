defmodule PickleballLeague.PlayerTest do
  use PickleballLeague.ModelCase

  alias PickleballLeague.Player

  @valid_attrs %{first_name: "some content", last_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Player.changeset(%Player{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Player.changeset(%Player{}, @invalid_attrs)
    refute changeset.valid?
  end
end
