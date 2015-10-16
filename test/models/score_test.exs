defmodule PickleballLeague.ScoreTest do
  use PickleballLeague.ModelCase

  alias PickleballLeague.Score

  @valid_attrs %{points: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Score.changeset(%Score{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Score.changeset(%Score{}, @invalid_attrs)
    refute changeset.valid?
  end
end
