defmodule PickleballLeague.GameController do
  use PickleballLeague.Web, :controller

  alias PickleballLeague.Game
  alias PickleballLeague.Score
  alias PickleballLeague.Player
  alias PickleballLeague.Roster
  alias PickleballLeague.Team

  plug :scrub_params, "game" when action in [:update]

  def index(conn, _params) do
    games = Repo.all(Game) |> Repo.preload([:scores, teams: :players])
    render(conn, "index.html", games: games)
  end

  def new(conn, _params) do
    changeset = Game.changeset(%Game{})
    players = Repo.all(Player)
    render(conn, "new.html", changeset: changeset, players: players)
  end

  def create(conn, %{"Home-Team" => home_players, "Away-Team" => away_players} = game_params) do
    teams = [Enum.map(home_players, &String.to_integer/1), Enum.map(away_players, &String.to_integer/1)]
    changeset_params = case game_params do
      %{"group_id" => group_id} -> %{"group_id" => group_id}
      _ -> %{}
    end
    case Repo.insert(Game.changeset(%Game{}, changeset_params)) do
      {:ok, game} ->
        setup_records_for_game(teams, game.id)
        redirect(conn, to: game_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def setup_records_for_game(teams, game_id) do
    find_or_create(teams)
    |> create_rosters
    |> create_scores(game_id)
  end

  defp find_or_create([player_ids | []]) do
    [find_or_create_team_for(player_ids)]
  end

  defp find_or_create([player_ids | other_teams]) do
    [find_or_create_team_for(player_ids) | find_or_create(other_teams)]
  end

  defp find_or_create_team_for(player_ids) do
    query = """
    SELECT *
    FROM rosters
    WHERE player_id IN (#{Enum.join(player_ids, ",")})
    """
    {:ok, %{columns: columns, rows: rows}} = Ecto.Adapters.SQL.query(Repo, query, [])

    rows
    |> Enum.map(fn row -> Enum.zip(columns, row) |> Enum.into(%{}) end)
    |> Enum.reduce(%{}, fn (row, map) ->
      Map.update(map, row["team_id"], [row["player_id"]], &([row["player_id"] | &1]))
    end)
    |> Enum.find(fn {_team_id, players} -> Enum.sort(players) == Enum.sort(player_ids) end)
    |> case do
      {team_id, _players} -> {:previous, team_id, player_ids}
      nil -> {:new, create_and_get_team(), player_ids}
    end
  end

  defp create_and_get_team do
    case Repo.insert(Team.changeset(%Team{}, %{})) do
      {:ok, team} -> team.id
      {:error, changeset} -> changeset
    end
  end

  defp create_rosters(teams) do
    Enum.map(teams, &create_roster/1)
  end

  defp create_roster({:previous, team_id, _player_ids}), do: team_id
  defp create_roster({:new, team_id, player_ids}) do
    player_ids
    |> Enum.each(fn player_id ->
      Repo.insert(Roster.changeset(%Roster{}, %{team_id: team_id, player_id: player_id}))
    end)

    team_id
  end

  def create_scores(teams, game_id) do
    teams
    |> Enum.each(fn team_id ->
      Repo.insert(Score.changeset(%Score{}, %{team_id: team_id, game_id: game_id, points: 0}))
    end)
  end

  def show(conn, %{"id" => id}) do
    game = Repo.get!(Game, id) |> Repo.preload(:scores)
    render(conn, "show.html", game: game)
  end

  def edit(conn, %{"id" => id}) do
    game = Repo.get!(Game, id) |> Repo.preload([:scores, teams: :players])
    changeset = Game.changeset(game)
    render(conn, "edit.html", game: game, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Repo.get!(Game, id) |> Repo.preload(:scores)
    changeset = Game.changeset(game, game_params)

    case Repo.update(changeset) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game updated successfully.")
        |> redirect(to: game_path(conn, :show, game))
      {:error, changeset} ->
        render(conn, "edit.html", game: game, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Repo.get!(Game, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(game)

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: game_path(conn, :index))
  end
end
