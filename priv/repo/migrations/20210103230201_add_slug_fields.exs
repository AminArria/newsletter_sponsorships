defmodule Sponsorly.Repo.Migrations.AddSlugFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slug, :string
    end

    alter table(:newsletters) do
      add :slug, :string
    end

    create unique_index(:users, [:slug])
    create unique_index(:newsletters, [:slug, :user_id])
  end
end
