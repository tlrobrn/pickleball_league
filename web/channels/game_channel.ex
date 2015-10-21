defmodule PickleballLeague.GameChannel do
  use PickleballLeague.Web, :channel
  alias PickleballLeague.Game
  alias PickleballLeague.Score
  alias PickleballLeague.EarnedPointsRatio

  def join("games:" <> game_id, params, socket) do
    {:ok, assign(socket, :game_id, game_id) }
  end

  def handle_in("point", %{"scores" => scores}, socket) do
    update_scores("point", scores, socket)
  end

  def handle_in("game_over", %{"id" => game_id, "scores" => scores}, socket) do
    case update_scores("game_over", scores, socket) do
      {:reply, :ok, socket} -> calculate_epr(game_id, socket)
      error -> error
    end
  end

  defp update_scores(message, [score | []], socket) do
    update_score(message, score, socket)
  end
  defp update_scores(message, [score | scores], socket) do
    update_score(message, score, socket)
    update_scores(message, scores, socket)
  end

  defp update_score(message, %{"id" => score_id, "points" => points} = params, socket) do
    require Logger
    Logger.debug "SCORE_ID: #{score_id}, POINTS: #{points}"
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

  defp calculate_epr(game_id, socket) do
    EarnedPointsRatio.calculate(Repo.get(Game, game_id))

    {:reply, :ok, socket}
  end
end
