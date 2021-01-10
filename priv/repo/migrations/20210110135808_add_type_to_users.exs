defmodule Sponsorly.Repo.Migrations.AddTypeToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_sponsor, :boolean, default: true, null: false
      add :is_creator, :boolean, default: true, null: false
    end
  end
end
