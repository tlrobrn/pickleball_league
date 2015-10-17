defmodule PickleballLeague.GameChannel do
  use PickleballLeague.Web, :channel
  alias PickleballLeague.Game
  alias PickleballLeague.Score
  alias PickleballLeague.EarnedPointsRatio

  def join("games:" <> game_id, params, socket) do
    {:ok, assign(socket, :game_id, game_id) }
  end

  def handle_in("point", %{"score_id" => score_id, "points" => points} = params, socket) do
    update_score("point", params, socket)
  end

  def handle_in("game_over", %{"score_id" => score_id, "points" => points} = params, socket) do
    case update_score("game_over", params, socket) do
      {:reply, :ok, socket} -> calculate_epr(socket)
      error -> error
    end
  end

  defp update_score(message, %{"score_id" => score_id, "points" => points} = params, socket) do
    Score
    |> Repo.get(score_id)
    |> Score.changeset(%{points: points})
    |> Repo.update()
    |> case do
      {:ok, _score} ->
        broadcast!(socket, message, params)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{reasons: changeset}}, socket}
    end
  end

  defp calculate_epr(socket) do
    game = Game
            |> Repo.get(socket.assigns.game_id)
            |> Repo.preload([:scores, teams: :players])

    {:reply, :ok, socket}
  end
end
