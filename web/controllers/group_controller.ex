defmodule PickleballLeague.GroupController do
  use PickleballLeague.Web, :controller

  alias PickleballLeague.Group
  alias PickleballLeague.Player
  alias PickleballLeague.PlayerGroup

  plug :scrub_params, "group" when action in [:create, :update]

  def index(conn, _params) do
    groups = Repo.all(Group)
    render(conn, "index.html", groups: groups)
  end

  def new(conn, _params) do
    changeset = Group.changeset(%Group{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"group" => group_params}) do
    Player
    |> Repo.all
    |> determine_groups
    |> create_groups

    redirect(conn, to: group_path(conn, :index))
  end

  defp create_groups(groups) do
    groups |> Enum.with_index |> Enum.each(&create_group/1)
  end

  defp create_group({players, index}) do
    Group.changeset(%Group{}, %{name: "#{index + 1}"})
    |> Repo.insert
    |> associate(players)
  end

  defp associate({:ok, group}, players) do
    players
    |> Enum.each(fn player ->
      PlayerGroup.changeset(%PlayerGroup{}, %{player_id: player.id, group_id: group.id})
      |> Repo.insert
    end)
  end

  defp determine_groups(players) do
    :random.seed(:os.timestamp)
    players
    |> Enum.shuffle
    |> determine_groups(length(players))
  end

  defp determine_groups(players, 8) do
    players |> Enum.chunk(4)
  end
  defp determine_groups(players, 9) do
    {group1, group2} = players |> Enum.split(4)
    [group1, group2]
  end
  defp determine_groups(players, 10) do
    players |> Enum.chunk(5)
  end
  defp determine_groups(players, 11) do
    [players]
  end
  defp determine_groups(players, 12) do
    players |> Enum.chunk(4)
  end
  defp determine_groups(players, 13) do
    {first_group, remaining_players} = players |> Enum.split(5)
    [first_group | Enum.chunk(remaining_players, 4)]
  end
  defp determine_groups(players, 14) do
    {first_group, remaining_players} = players |> Enum.split(4)
    [first_group | Enum.chunk(remaining_players, 5)]
  end
  defp determine_groups(players, 15) do
    players |> Enum.chunk(5)
  end
  defp determine_groups(players, 16) do
    players |> Enum.chunk(4)
  end

  def show(conn, %{"id" => id}) do
    group = Repo.get!(Group, id)
    render(conn, "show.html", group: group)
  end

  def edit(conn, %{"id" => id}) do
    group = Repo.get!(Group, id)
    changeset = Group.changeset(group)
    render(conn, "edit.html", group: group, changeset: changeset)
  end

  def update(conn, %{"id" => id, "group" => group_params}) do
    group = Repo.get!(Group, id)
    changeset = Group.changeset(group, group_params)

    case Repo.update(changeset) do
      {:ok, group} ->
        conn
        |> put_flash(:info, "Group updated successfully.")
        |> redirect(to: group_path(conn, :show, group))
      {:error, changeset} ->
        render(conn, "edit.html", group: group, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    group = Repo.get!(Group, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(group)

    conn
    |> put_flash(:info, "Group deleted successfully.")
    |> redirect(to: group_path(conn, :index))
  end
end
