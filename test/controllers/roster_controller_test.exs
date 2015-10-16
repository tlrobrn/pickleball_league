defmodule PickleballLeague.RosterControllerTest do
  use PickleballLeague.ConnCase

  alias PickleballLeague.Roster
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, roster_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing rosters"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, roster_path(conn, :new)
    assert html_response(conn, 200) =~ "New roster"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, roster_path(conn, :create), roster: @valid_attrs
    assert redirected_to(conn) == roster_path(conn, :index)
    assert Repo.get_by(Roster, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, roster_path(conn, :create), roster: @invalid_attrs
    assert html_response(conn, 200) =~ "New roster"
  end

  test "shows chosen resource", %{conn: conn} do
    roster = Repo.insert! %Roster{}
    conn = get conn, roster_path(conn, :show, roster)
    assert html_response(conn, 200) =~ "Show roster"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, roster_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    roster = Repo.insert! %Roster{}
    conn = get conn, roster_path(conn, :edit, roster)
    assert html_response(conn, 200) =~ "Edit roster"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    roster = Repo.insert! %Roster{}
    conn = put conn, roster_path(conn, :update, roster), roster: @valid_attrs
    assert redirected_to(conn) == roster_path(conn, :show, roster)
    assert Repo.get_by(Roster, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    roster = Repo.insert! %Roster{}
    conn = put conn, roster_path(conn, :update, roster), roster: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit roster"
  end

  test "deletes chosen resource", %{conn: conn} do
    roster = Repo.insert! %Roster{}
    conn = delete conn, roster_path(conn, :delete, roster)
    assert redirected_to(conn) == roster_path(conn, :index)
    refute Repo.get(Roster, roster.id)
  end
end
