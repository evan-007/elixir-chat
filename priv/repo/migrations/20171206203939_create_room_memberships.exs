defmodule PLMLive.Repo.Migrations.CreateRoomMemberships do
  use Ecto.Migration

  def change do
    create table(:room_memberships) do
      add :user_id, references(:users, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:room_memberships, [:user_id])
    create index(:room_memberships, [:room_id])
  end
end
