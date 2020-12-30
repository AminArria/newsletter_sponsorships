defmodule Sponsorly.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :deleted, :boolean, default: false, null: false
      add :due_at, :utc_datetime, null: false
      add :name, :string
      add :newsletter_id, references(:newsletters, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:issues, [:newsletter_id])
  end
end
