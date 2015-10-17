defmodule PickleballLeague.GameChannel do
  use PickleballLeague.Web, :channel
  alias PickleballLeague.Game
  alias PickleballLeague.Score

  def join("games:" <> game_id, params, socket) do
    {:ok, assign(socket, :game_id, game_id) }
  end

  def handle_in("point", %{"score_id" => score_id, "points" => points} = params, socket) do
    Score
    |> Repo.get(score_id)
    |> Score.changeset(%{points: points})
    |> Repo.update()
    |> case do
      {:ok, _score} ->
        broadcast!(socket, "point", params)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{reasons: changeset}}, socket}
    end
  end

  def handle_in("game_over", %{player_ids: player_ids}, socket) do
    Player
    |> Repo.all
    |> Enum.each(&calculate_epr/1)

    {:reply, :ok, socket}
  end

  defp calculate_epr(player) do
  end
end
