defmodule PLMLive.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias PLMLive.Repo

  alias PLMLive.Chats.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a user by plm_id
  """

  def get_plm_user!(plm_id) do
    query = from u in User, where: [plm_id: ^plm_id]
    Repo.all(query)
  end

  @doc """
  Gets a user by login
  """

  def get_user_by_login!(login) do
    query = from u in User, where: [login: ^login]
    Repo.all(query)
    |> List.first()
  end

  @doc """
  returns a list of all chats the user is involved in
  """

  def get_plm_user_chats!(plm_id) do
    query = from u in User, where: [plm_id: ^plm_id]
    Repo.all(query)
    |> Repo.preload(:rooms)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias PLMLive.Chats.Room

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
    |> Repo.preload(:users)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  @doc """
  gets a room by its name

  ## Examples

      iex> get_room_by_name('cats')
      {:ok, %Room{}}

      iex> get_room_by_name('dogs')
      nil

  """

  def get_room_by_name(name) do
    query = from room in Room, where: [name: ^name] # wtf pin operator
    rooms = Repo.all(query)
    case length(rooms) do
      1 ->
        List.first rooms
      _ ->
        nil
    end
  end

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  creates a chatroom for two or more user ids
  curl -H "Content-Type: application/json" -d '{"room": { "user_ids": [1,2]}}' -X POST localhost:4000/api/rooms
  """

  def create_room_for_users(attrs \\ %{}) do
    name = attrs["user_ids"]
           |> Enum.join("-")
    room_attrs = %{name: name}
    {:ok, room} = %Room{}
                  |> Room.changeset(room_attrs)
                  |> Repo.insert
    user_ids = attrs["user_ids"]
    Enum.each(user_ids, fn(id) ->
      {:ok, membership} = %{user_id: id, room_id: room.id}
                          |> create_room_membership()
    end)
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{source: %Room{}}

  """
  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  alias PLMLive.Chats.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Returns the list of recent messages for a room.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def recent_messages_for_room(room_name) do
    room = case room_name do
      "lobby" ->
        get_room_by_name(room_name)
      _ -> get_room!(room_name) # is actually an id :(
    end
    room_id = room.id
    query = from m in Message,
      where: [room_id: ^room_id],
      order_by: [desc: m.inserted_at],
      preload: [:user]
    Repo.all(query)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end

  alias PLMLive.Chats.RoomMembership

  @doc """
  Returns the list of room_memberships.

  ## Examples

      iex> list_room_memberships()
      [%RoomMembership{}, ...]

  """
  def list_room_memberships do
    Repo.all(RoomMembership)
  end

  @doc """
  Gets a single room_membership.

  Raises `Ecto.NoResultsError` if the Room membership does not exist.

  ## Examples

      iex> get_room_membership!(123)
      %RoomMembership{}

      iex> get_room_membership!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room_membership!(id), do: Repo.get!(RoomMembership, id)

  @doc """
  Creates a room_membership.

  ## Examples

      iex> create_room_membership(%{field: value})
      {:ok, %RoomMembership{}}

      iex> create_room_membership(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room_membership(attrs \\ %{}) do
    %RoomMembership{}
    |> RoomMembership.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room_membership.

  ## Examples

      iex> update_room_membership(room_membership, %{field: new_value})
      {:ok, %RoomMembership{}}

      iex> update_room_membership(room_membership, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room_membership(%RoomMembership{} = room_membership, attrs) do
    room_membership
    |> RoomMembership.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a RoomMembership.

  ## Examples

      iex> delete_room_membership(room_membership)
      {:ok, %RoomMembership{}}

      iex> delete_room_membership(room_membership)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room_membership(%RoomMembership{} = room_membership) do
    Repo.delete(room_membership)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room_membership changes.

  ## Examples

      iex> change_room_membership(room_membership)
      %Ecto.Changeset{source: %RoomMembership{}}

  """
  def change_room_membership(%RoomMembership{} = room_membership) do
    RoomMembership.changeset(room_membership, %{})
  end
end
