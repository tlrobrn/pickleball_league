defmodule PickleballLeague.PageView do
  use PickleballLeague.Web, :view

  def group_column_class(groups) do
    "col-lg-#{div(12, length(groups))}"
  end
end
