defmodule Sponsorly.Repo.Migrations.RemoveUserFromConfirmedSponsorship do
  use Ecto.Migration

  def change do
    alter table(:confirmed_sponsorships) do
      remove :user_id
    end
  end
end
