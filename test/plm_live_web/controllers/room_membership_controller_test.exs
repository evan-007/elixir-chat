defmodule PLMLiveWeb.RoomMembershipControllerTest do
  use PLMLiveWeb.ConnCase

  alias PLMLive.Chats
  alias PLMLive.Chats.RoomMembership

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:room_membership) do
    {:ok, room_membership} = Chats.create_room_membership(@create_attrs)
    room_membership
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all room_memberships", %{conn: conn} do
      conn = get conn, room_membership_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create room_membership" do
    test "renders room_membership when data is valid", %{conn: conn} do
      conn = post conn, room_membership_path(conn, :create), room_membership: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, room_membership_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, room_membership_path(conn, :create), room_membership: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update room_membership" do
    setup [:create_room_membership]

    test "renders room_membership when data is valid", %{conn: conn, room_membership: %RoomMembership{id: id} = room_membership} do
      conn = put conn, room_membership_path(conn, :update, room_membership), room_membership: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, room_membership_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, room_membership: room_membership} do
      conn = put conn, room_membership_path(conn, :update, room_membership), room_membership: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete room_membership" do
    setup [:create_room_membership]

    test "deletes chosen room_membership", %{conn: conn, room_membership: room_membership} do
      conn = delete conn, room_membership_path(conn, :delete, room_membership)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, room_membership_path(conn, :show, room_membership)
      end
    end
  end

  defp create_room_membership(_) do
    room_membership = fixture(:room_membership)
    {:ok, room_membership: room_membership}
  end
end
