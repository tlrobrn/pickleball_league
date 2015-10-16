defmodule PickleballLeague.EarnedPointsRatioControllerTest do
  use PickleballLeague.ConnCase

  alias PickleballLeague.EarnedPointsRatio
  @valid_attrs %{value: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, earned_points_ratio_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing earned points ratios"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, earned_points_ratio_path(conn, :new)
    assert html_response(conn, 200) =~ "New earned points ratio"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, earned_points_ratio_path(conn, :create), earned_points_ratio: @valid_attrs
    assert redirected_to(conn) == earned_points_ratio_path(conn, :index)
    assert Repo.get_by(EarnedPointsRatio, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, earned_points_ratio_path(conn, :create), earned_points_ratio: @invalid_attrs
    assert html_response(conn, 200) =~ "New earned points ratio"
  end

  test "shows chosen resource", %{conn: conn} do
    earned_points_ratio = Repo.insert! %EarnedPointsRatio{}
    conn = get conn, earned_points_ratio_path(conn, :show, earned_points_ratio)
    assert html_response(conn, 200) =~ "Show earned points ratio"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, earned_points_ratio_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    earned_points_ratio = Repo.insert! %EarnedPointsRatio{}
    conn = get conn, earned_points_ratio_path(conn, :edit, earned_points_ratio)
    assert html_response(conn, 200) =~ "Edit earned points ratio"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    earned_points_ratio = Repo.insert! %EarnedPointsRatio{}
    conn = put conn, earned_points_ratio_path(conn, :update, earned_points_ratio), earned_points_ratio: @valid_attrs
    assert redirected_to(conn) == earned_points_ratio_path(conn, :show, earned_points_ratio)
    assert Repo.get_by(EarnedPointsRatio, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    earned_points_ratio = Repo.insert! %EarnedPointsRatio{}
    conn = put conn, earned_points_ratio_path(conn, :update, earned_points_ratio), earned_points_ratio: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit earned points ratio"
  end

  test "deletes chosen resource", %{conn: conn} do
    earned_points_ratio = Repo.insert! %EarnedPointsRatio{}
    conn = delete conn, earned_points_ratio_path(conn, :delete, earned_points_ratio)
    assert redirected_to(conn) == earned_points_ratio_path(conn, :index)
    refute Repo.get(EarnedPointsRatio, earned_points_ratio.id)
  end
end
