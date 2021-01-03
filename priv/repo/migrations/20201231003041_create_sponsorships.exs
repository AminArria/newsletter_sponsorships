defmodule Sponsorly.Repo.Migrations.CreateSponsorships do
  use Ecto.Migration

  def change do
    create table(:sponsorships) do
      add :copy, :text, null: false
      add :deleted, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :issue_id, references(:issues, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:sponsorships, [:user_id])
    create index(:sponsorships, [:issue_id])
  end
end
