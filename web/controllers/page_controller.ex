defmodule PickleballLeague.PageController do
  use PickleballLeague.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
