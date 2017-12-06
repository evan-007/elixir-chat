defmodule PLMLive.Chats.RoomMembership do
  use Ecto.Schema
  import Ecto.Changeset
  alias PLMLive.Chats.RoomMembership


  schema "room_memberships" do
    belongs_to :user, PLMLive.Chats.User
    belongs_to :room, PLMLive.Chats.Room

    timestamps()
  end

  @doc false
  def changeset(%RoomMembership{} = room_membership, attrs) do
    room_membership
    |> cast(attrs, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
  end
end
