defmodule PickleballLeague.PlayerController do
  use PickleballLeague.Web, :controller

  alias PickleballLeague.Player

  plug :scrub_params, "player" when action in [:create, :update]

  def index(conn, _params) do
    players = Repo.all(Player) |> Repo.preload(:earned_points_ratios)
    render(conn, "index.html", players: players, opponent_eprs: opponent_eprs)
  end

  def opponent_eprs do
    opponents_played
    |> Enum.map(&calculate_opponent_epr/1)
    |> Enum.into(%{})
  end

  defp opponents_played do
    query = """
    select distinct P.id, O.player_id as opponent_id
    from players P
    join rosters R on P.id = R.player_id
    join teams T on T.id = R.team_id
    join scores S on S.team_id = T.id
    join scores OS on OS.game_id = S.game_id and OS.team_id <> S.team_id
    join teams OT on OT.id = OS.team_id
    join rosters O on O.team_id = OT.id
    """
    {:ok, %{columns: columns, rows: rows}} = Ecto.Adapters.SQL.query(Repo, query, [])

    rows
    |> Enum.map(fn row -> Enum.zip(columns, row) |> Enum.into(%{}) end)
    |> Enum.reduce(%{}, fn (row, map) ->
      Map.update(map, row["id"], [row["opponent_id"]], &([row["opponent_id"] | &1]))
    end)
  end

  defp calculate_opponent_epr({player_id, opponent_ids}) do
    query = """
    select sum(earned_points)::float / sum(total_points) as epr
    from earned_points_ratios
    where player_id IN (#{Enum.join(opponent_ids, ",")})
    """
    {:ok, %{columns: columns, rows: rows}} = Ecto.Adapters.SQL.query(Repo, query, [])

    epr = case rows do
      [[nil]] -> nil
      results ->
        results
        |> Enum.map(fn row -> Enum.zip(columns, row) |> Enum.into(%{}) end)
        |> Enum.reduce(0, fn (%{"epr" => epr}, acc) -> epr + acc end)
    end

    {player_id, epr}
  end

  def new(conn, _params) do
    changeset = Player.changeset(%Player{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"player" => player_params}) do
    changeset = Player.changeset(%Player{}, player_params)

    case Repo.insert(changeset) do
      {:ok, _player} ->
        conn
        |> put_flash(:info, "Player created successfully.")
        |> redirect(to: player_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    player = Repo.get!(Player, id)
    render(conn, "show.html", player: player)
  end

  def edit(conn, %{"id" => id}) do
    player = Repo.get!(Player, id)
    changeset = Player.changeset(player)
    render(conn, "edit.html", player: player, changeset: changeset)
  end

  def update(conn, %{"id" => id, "player" => player_params}) do
    player = Repo.get!(Player, id)
    changeset = Player.changeset(player, player_params)

    case Repo.update(changeset) do
      {:ok, player} ->
        conn
        |> put_flash(:info, "Player updated successfully.")
        |> redirect(to: player_path(conn, :show, player))
      {:error, changeset} ->
        render(conn, "edit.html", player: player, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    player = Repo.get!(Player, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(player)

    conn
    |> put_flash(:info, "Player deleted successfully.")
    |> redirect(to: player_path(conn, :index))
  end
end
