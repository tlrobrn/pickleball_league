defmodule PickleballLeague.EarnedPointsRatioController do
  use PickleballLeague.Web, :controller

  alias PickleballLeague.EarnedPointsRatio

  plug :scrub_params, "earned_points_ratio" when action in [:create, :update]

  def index(conn, _params) do
    earned_points_ratios = Repo.all(EarnedPointsRatio)
    render(conn, "index.html", earned_points_ratios: earned_points_ratios)
  end

  def new(conn, _params) do
    changeset = EarnedPointsRatio.changeset(%EarnedPointsRatio{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"earned_points_ratio" => earned_points_ratio_params}) do
    changeset = EarnedPointsRatio.changeset(%EarnedPointsRatio{}, earned_points_ratio_params)

    case Repo.insert(changeset) do
      {:ok, _earned_points_ratio} ->
        conn
        |> put_flash(:info, "Earned points ratio created successfully.")
        |> redirect(to: earned_points_ratio_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    earned_points_ratio = Repo.get!(EarnedPointsRatio, id)
    render(conn, "show.html", earned_points_ratio: earned_points_ratio)
  end

  def edit(conn, %{"id" => id}) do
    earned_points_ratio = Repo.get!(EarnedPointsRatio, id)
    changeset = EarnedPointsRatio.changeset(earned_points_ratio)
    render(conn, "edit.html", earned_points_ratio: earned_points_ratio, changeset: changeset)
  end

  def update(conn, %{"id" => id, "earned_points_ratio" => earned_points_ratio_params}) do
    earned_points_ratio = Repo.get!(EarnedPointsRatio, id)
    changeset = EarnedPointsRatio.changeset(earned_points_ratio, earned_points_ratio_params)

    case Repo.update(changeset) do
      {:ok, earned_points_ratio} ->
        conn
        |> put_flash(:info, "Earned points ratio updated successfully.")
        |> redirect(to: earned_points_ratio_path(conn, :show, earned_points_ratio))
      {:error, changeset} ->
        render(conn, "edit.html", earned_points_ratio: earned_points_ratio, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    earned_points_ratio = Repo.get!(EarnedPointsRatio, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(earned_points_ratio)

    conn
    |> put_flash(:info, "Earned points ratio deleted successfully.")
    |> redirect(to: earned_points_ratio_path(conn, :index))
  end
end
