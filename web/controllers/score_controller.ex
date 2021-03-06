defmodule PickleballLeague.ScoreController do
  use PickleballLeague.Web, :controller

  alias PickleballLeague.Score

  plug :scrub_params, "score" when action in [:create, :update]

  def index(conn, _params) do
    scores = Repo.all(Score)
    render(conn, "index.html", scores: scores)
  end

  def new(conn, _params) do
    changeset = Score.changeset(%Score{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"score" => score_params}) do
    changeset = Score.changeset(%Score{}, score_params)

    case Repo.insert(changeset) do
      {:ok, _score} ->
        conn
        |> put_flash(:info, "Score created successfully.")
        |> redirect(to: score_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    score = Repo.get!(Score, id)
    render(conn, "show.html", score: score)
  end

  def edit(conn, %{"id" => id}) do
    score = Repo.get!(Score, id)
    changeset = Score.changeset(score)
    render(conn, "edit.html", score: score, changeset: changeset)
  end

  def update(conn, %{"id" => id, "score" => score_params}) do
    score = Repo.get!(Score, id)
    changeset = Score.changeset(score, score_params)

    case Repo.update(changeset) do
      {:ok, score} ->
        conn
        |> put_flash(:info, "Score updated successfully.")
        |> redirect(to: score_path(conn, :show, score))
      {:error, changeset} ->
        render(conn, "edit.html", score: score, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    score = Repo.get!(Score, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(score)

    conn
    |> put_flash(:info, "Score deleted successfully.")
    |> redirect(to: score_path(conn, :index))
  end
end
