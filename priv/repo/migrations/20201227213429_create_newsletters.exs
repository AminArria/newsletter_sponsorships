defmodule Sponsorly.Repo.Migrations.CreateNewsletters do
  use Ecto.Migration

  def change do
    create table(:newsletters) do
      add :interval_days, :integer, null: false
      add :name, :string, null: false
      add :sponsor_before_days, :integer, null: false
      add :sponsor_in_days, :integer, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :deleted, :boolean, default: false, null: false

      timestamps()
    end

    create index(:newsletters, [:user_id])
  end
end
