defmodule PLMLive.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string
      add :plm_id, :integer

      timestamps()
    end

    create unique_index :users, :login
    create unique_index :users, :plm_id
  end
end
