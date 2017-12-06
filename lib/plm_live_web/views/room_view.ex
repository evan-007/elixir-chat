defmodule PLMLiveWeb.RoomView do
  use PLMLiveWeb, :view
  alias PLMLiveWeb.RoomView

  def render("index.json", %{rooms: rooms}) do
    %{data: render_many(rooms, RoomView, "room.json")}
  end

  def render("show.json", %{room: room}) do
    %{data: render_one(room, RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{id: room.id,
      name: room.name,
      users: Enum.map(room.users, &users_json(&1)) # this is not the right way to do it
    }
  end

  defp users_json(user) do
    user.login
  end
end
