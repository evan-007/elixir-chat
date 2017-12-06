defmodule PLMLive.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias PLMLive.Chats.Message


  schema "messages" do
    field :content, :string
    field :room_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:content, :user_id, :room_id])
    |> validate_required([:content, :user_id, :room_id])
  end
end
