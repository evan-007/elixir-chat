defmodule PLMLive.Chats.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias PLMLive.Chats.Room


  schema "rooms" do
    field :name, :string
    has_many :room_memberships, PLMLive.Chats.RoomMembership
    many_to_many :users, PLMLive.Chats.User, join_through: PLMLive.Chats.RoomMembership

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name])
    |> unique_constraint(:name)
  end
end
