defmodule Sponsorly.Repo.Migrations.CreateConfirmedSponsorships do
  use Ecto.Migration

  def change do
    create table(:confirmed_sponsorships) do
      add :copy, :text, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :issue_id, references(:issues, on_delete: :nothing), null: false
      add :sponsorship_id, references(:sponsorships, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:confirmed_sponsorships, [:user_id])
    create index(:confirmed_sponsorships, [:sponsorship_id])
    create unique_index(:confirmed_sponsorships, [:issue_id])
  end
end
