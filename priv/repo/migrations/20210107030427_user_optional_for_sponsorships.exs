defmodule Sponsorly.Repo.Migrations.UserOptionalForSponsorships do
  use Ecto.Migration

  def change do
    alter table(:sponsorships) do
      add :email, :string
      modify :user_id, references(:users, on_delete: :nothing), from: references(:users, on_delete: :nothing), null: true
    end

    alter table(:confirmed_sponsorships) do
      add :email, :string
      modify :user_id, references(:users, on_delete: :nothing), from: references(:users, on_delete: :nothing), null: true
    end
  end
end
