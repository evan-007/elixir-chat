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
end
