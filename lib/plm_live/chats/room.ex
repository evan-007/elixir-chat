defmodule PLMLive.Chats.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias PLMLive.Chats.Room


  schema "rooms" do
    field :name, :string
    has_many :room_memberships, PLMLive.Chats.RoomMembership
    has_many :users, through: [:room_memberships, :user]

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name])
    |> unique_constraint(:name)
    |> cast_assoc(:room_memberships)
    # |> validate_required([:name])
  end
end
