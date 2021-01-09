defmodule Sponsorly.Repo.Migrations.ChangeDueAtToDate do
  use Ecto.Migration

  def change do
    alter table(:issues) do
      modify :due_at, :date, null: false, from: :utc_datetime
    end

    rename table(:issues), :due_at, to: :due_date
  end
end
