defmodule PLMLiveWeb.RoomChannel do
  use Phoenix.Channel
  # alias PLMLiveWeb.Presence
  import Ecto.UUID, only: [generate: 0]

  def join("room:lobby", message, socket) do
    socket = assign(socket, :user, message["user"])
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("room:" <> private_room_id, message, socket) do
    socket = assign(socket, :user, message["user"])
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body, "user" => user}, socket) do
    broadcast! socket, "new_msg", %{
      body: body,
      user: user,
      uuid: generate(),
      timestamp: :os.system_time(:milli_seconds)
    }
    {:noreply, socket}
  end

  def handle_in("new_user", %{"user" => user}, socket) do
    # this should be in a handle_info clause w/after_join
    broadcast! socket, "new_user", %{
      user: user,
      uuid: generate(),
      timestamp: :os.system_time(:milli_seconds)
    }
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    # push socket, "presence_state", Presence.list(socket)
    # {:ok, _} = Presence.track(socket, socket.assigns.user, %{
    #   online_at: inspect(System.system_time(:milli_seconds)),
    #   user: socket.assigns.user
    # })
    {:noreply, socket}
  end
end
