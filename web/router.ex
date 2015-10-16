defmodule PickleballLeague.Router do
  use PickleballLeague.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PickleballLeague do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/players", PlayerController
    resources "/teams", TeamController
    resources "/rosters", RosterController
    resources "/games", GameController
    resources "/scores", ScoreController
    resources "/earned_points_ratios", EarnedPointsRatioController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PickleballLeague do
  #   pipe_through :api
  # end
end
