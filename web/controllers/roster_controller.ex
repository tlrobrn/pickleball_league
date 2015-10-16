defmodule PickleballLeague.RosterController do
  use PickleballLeague.Web, :controller

  alias PickleballLeague.Roster

  plug :scrub_params, "roster" when action in [:create, :update]

  def index(conn, _params) do
    rosters = Repo.all(Roster)
    render(conn, "index.html", rosters: rosters)
  end

  def new(conn, _params) do
    changeset = Roster.changeset(%Roster{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"roster" => roster_params}) do
    changeset = Roster.changeset(%Roster{}, roster_params)

    case Repo.insert(changeset) do
      {:ok, _roster} ->
        conn
        |> put_flash(:info, "Roster created successfully.")
        |> redirect(to: roster_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    roster = Repo.get!(Roster, id)
    render(conn, "show.html", roster: roster)
  end

  def edit(conn, %{"id" => id}) do
    roster = Repo.get!(Roster, id)
    changeset = Roster.changeset(roster)
    render(conn, "edit.html", roster: roster, changeset: changeset)
  end

  def update(conn, %{"id" => id, "roster" => roster_params}) do
    roster = Repo.get!(Roster, id)
    changeset = Roster.changeset(roster, roster_params)

    case Repo.update(changeset) do
      {:ok, roster} ->
        conn
        |> put_flash(:info, "Roster updated successfully.")
        |> redirect(to: roster_path(conn, :show, roster))
      {:error, changeset} ->
        render(conn, "edit.html", roster: roster, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    roster = Repo.get!(Roster, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(roster)

    conn
    |> put_flash(:info, "Roster deleted successfully.")
    |> redirect(to: roster_path(conn, :index))
  end
end
