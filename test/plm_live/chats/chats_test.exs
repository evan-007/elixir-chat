defmodule PLMLive.ChatsTest do
  use PLMLive.DataCase

  alias PLMLive.Chats

  describe "users" do
    alias PLMLive.Chats.User

    @valid_attrs %{login: "some login", plm_id: 42}
    @update_attrs %{login: "some updated login", plm_id: 43}
    @invalid_attrs %{login: nil, plm_id: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chats.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Chats.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Chats.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Chats.create_user(@valid_attrs)
      assert user.login == "some login"
      assert user.plm_id == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Chats.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.login == "some updated login"
      assert user.plm_id == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_user(user, @invalid_attrs)
      assert user == Chats.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Chats.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Chats.change_user(user)
    end
  end

  describe "rooms" do
    alias PLMLive.Chats.Room

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chats.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Chats.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Chats.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Chats.create_room(@valid_attrs)
      assert room.name == "some name"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, room} = Chats.update_room(room, @update_attrs)
      assert %Room{} = room
      assert room.name == "some updated name"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_room(room, @invalid_attrs)
      assert room == Chats.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Chats.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Chats.change_room(room)
    end
  end

  describe "messages" do
    alias PLMLive.Chats.Message

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chats.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Chats.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Chats.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Chats.create_message(@valid_attrs)
      assert message.content == "some content"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, message} = Chats.update_message(message, @update_attrs)
      assert %Message{} = message
      assert message.content == "some updated content"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_message(message, @invalid_attrs)
      assert message == Chats.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Chats.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Chats.change_message(message)
    end
  end

  describe "room_memberships" do
    alias PLMLive.Chats.RoomMembership

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def room_membership_fixture(attrs \\ %{}) do
      {:ok, room_membership} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chats.create_room_membership()

      room_membership
    end

    test "list_room_memberships/0 returns all room_memberships" do
      room_membership = room_membership_fixture()
      assert Chats.list_room_memberships() == [room_membership]
    end

    test "get_room_membership!/1 returns the room_membership with given id" do
      room_membership = room_membership_fixture()
      assert Chats.get_room_membership!(room_membership.id) == room_membership
    end

    test "create_room_membership/1 with valid data creates a room_membership" do
      assert {:ok, %RoomMembership{} = room_membership} = Chats.create_room_membership(@valid_attrs)
    end

    test "create_room_membership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_room_membership(@invalid_attrs)
    end

    test "update_room_membership/2 with valid data updates the room_membership" do
      room_membership = room_membership_fixture()
      assert {:ok, room_membership} = Chats.update_room_membership(room_membership, @update_attrs)
      assert %RoomMembership{} = room_membership
    end

    test "update_room_membership/2 with invalid data returns error changeset" do
      room_membership = room_membership_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_room_membership(room_membership, @invalid_attrs)
      assert room_membership == Chats.get_room_membership!(room_membership.id)
    end

    test "delete_room_membership/1 deletes the room_membership" do
      room_membership = room_membership_fixture()
      assert {:ok, %RoomMembership{}} = Chats.delete_room_membership(room_membership)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_room_membership!(room_membership.id) end
    end

    test "change_room_membership/1 returns a room_membership changeset" do
      room_membership = room_membership_fixture()
      assert %Ecto.Changeset{} = Chats.change_room_membership(room_membership)
    end
  end
end
