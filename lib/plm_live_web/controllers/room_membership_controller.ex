defmodule PLMLiveWeb.RoomMembershipController do
  use PLMLiveWeb, :controller

  alias PLMLive.Chats
  alias PLMLive.Chats.RoomMembership

  action_fallback PLMLiveWeb.FallbackController

  def index(conn, _params) do
    room_memberships = Chats.list_room_memberships()
    render(conn, "index.json", room_memberships: room_memberships)
  end

  def create(conn, %{"room_membership" => room_membership_params}) do
    with {:ok, %RoomMembership{} = room_membership} <- Chats.create_room_membership(room_membership_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", room_membership_path(conn, :show, room_membership))
      |> render("show.json", room_membership: room_membership)
    end
  end

  def show(conn, %{"id" => id}) do
    room_membership = Chats.get_room_membership!(id)
    render(conn, "show.json", room_membership: room_membership)
  end

  def update(conn, %{"id" => id, "room_membership" => room_membership_params}) do
    room_membership = Chats.get_room_membership!(id)

    with {:ok, %RoomMembership{} = room_membership} <- Chats.update_room_membership(room_membership, room_membership_params) do
      render(conn, "show.json", room_membership: room_membership)
    end
  end

  def delete(conn, %{"id" => id}) do
    room_membership = Chats.get_room_membership!(id)
    with {:ok, %RoomMembership{}} <- Chats.delete_room_membership(room_membership) do
      send_resp(conn, :no_content, "")
    end
  end
end
