defmodule PLMLiveWeb.RoomChannel do
  use Phoenix.Channel
  alias PLMLiveWeb.Presence
  alias PLMLive.Chats
  import Ecto.UUID, only: [generate: 0]

  def join("room:lobby", message, socket) do
    socket = assign(socket, :user, message["user"])
    socket = assign(socket, :plm_id, message["plm_id"])
    {:ok, user} = create_user(%{ login: socket.assigns.user, plm_id: socket.assigns.plm_id })
    socket = assign(socket, :user_id, user.id)
    send(self(), :after_join)
    send(self(), :send_message_history)
    {:ok, socket}
  end

  def join("room:online", message, socket) do
    # no messages, only exists to track who is online
    socket = assign(socket, :user, message["user"])
    socket = assign(socket, :plm_id, message["plm_id"])
    {:ok, user} = create_user(%{ login: socket.assigns.user, plm_id: socket.assigns.plm_id })
    socket = assign(socket, :user_id, user.id)
    # sync presence
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("room:" <> private_room_id, message, socket) do
    # TODO: create room if not exists
    socket = assign(socket, :user, message["user"])
    socket = assign(socket, :plm_id, message["plm_id"])
    {:ok, user} = create_user(%{ login: socket.assigns.user, plm_id: socket.assigns.plm_id })
    socket = assign(socket, :user_id, user.id)
    send(self(), :after_join)
    send(self(), :send_message_history)
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
      timestamp: :os.system_time(:milli_seconds),
    }

    room_name = socket.topic
    |> String.split(":")
    |> List.last
    room = case room_name do
      "lobby" ->
        Chats.get_room_by_name(room_name)
      _ -> Chats.get_room!(room_name) # is actually an id :(
    end

    log_message(%{content: body,
      user_id: socket.assigns.user_id,
      room_id: room.id,
    })

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
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.user, %{
      online_at: inspect(System.system_time(:milli_seconds)),
      user: socket.assigns.user,
      plm_id: socket.assigns.plm_id,
    })
    {:noreply, socket}
  end

  def handle_info(:send_message_history, socket) do
    room_name = socket.topic
    |> String.split(":")
    |> List.last
    messages = get_messages(room_name)
               |> Enum.map(&serialize_message&1)
    broadcast! socket, "message_history", %{messages: messages}

    {:noreply, socket}
  end

  defp get_messages(room_name) do
    Chats.recent_messages_for_room(room_name)
  end

  defp create_user(user_attrs) do
    user = Chats.get_plm_user!(user_attrs.plm_id)
           |> List.first
    case user do
      nil ->
        Chats.create_user(user_attrs)
      _ ->
        {:ok, user}
    end
  end

  defp log_message(message) do
    Chats.create_message(message)
  end

  defp serialize_message(message) do
    %{
      body: message.content,
      uuid: message.id,
      user: message.user.login,
      timestamp: message.inserted_at,
    }
  end
end
