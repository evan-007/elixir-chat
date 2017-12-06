defmodule PLMLive.Chats.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PLMLive.Chats.User


  schema "users" do
    field :login, :string
    field :plm_id, :integer
    has_many :messages, PLMLive.Chats.Message

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:login, :plm_id])
    |> validate_required([:login, :plm_id])
    |> unique_constraint(:login)
    |> unique_constraint(:plm_id)
  end
end
