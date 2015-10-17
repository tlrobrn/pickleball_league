defmodule PickleballLeague.EarnedPointsRatio do
  use PickleballLeague.Web, :model
  alias PickleballLeague.Game
  alias PickleballLeague.Repo

  schema "earned_points_ratios" do
    field :value, :float
    belongs_to :player, PickleballLeague.Player
    belongs_to :game, Game

    timestamps
  end

  @required_fields ~w(value)
  @optional_fields ~w(game_id player_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def calculate(%Game{} = game) do
    epr_query(game)
    |> Enum.map(&(changeset(%PickleballLeague.EarnedPointsRatio{}, &1)))
    |> Enum.each(&Repo.insert!/1)
  end

  defp epr_query(game) do
    player_ids = Enum.map(game.players, &(&1.id)) |> Enum.join(",")
    query = """
    WITH games_played AS (
      SELECT G.id, R.team_id, R.player_id
      FROM games G
      JOIN scores S ON G.id = S.game_id
      JOIN rosters R ON S.team_id = R.team_id
      WHERE R.player_id IN (#{player_ids})
    ),
    player_scores AS (
      SELECT
        GP.player_id,
        GP.id,
        SUM(CASE WHEN S.team_id = GP.team_id THEN S.points ELSE 0 END) AS earned_pts,
        SUM(S.points) AS total_pts
      FROM scores S
      JOIN games_played GP ON S.game_id = GP.id
      GROUP BY 1, 2
    )
    SELECT player_id, SUM(earned_pts) / SUM(total_pts)::float AS value
    FROM player_scores PS
    GROUP BY 1
    """

    {:ok, %{columns: columns, rows: rows}} = Ecto.Adapters.SQL.query(Repo, query, [])
    Enum.map(rows, fn row -> Enum.zip(columns, row) |> Enum.into(%{"game_id" => game.id}) end)
  end
end
