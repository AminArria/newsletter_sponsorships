defmodule Sponsorly.Repo.Migrations.ChangeIntervalToSpecificDays do
  use Ecto.Migration

  def change do
    alter table(:newsletters) do
      remove :interval_days
      add :in_monday, :boolean, default: false, null: false
      add :in_tuesday, :boolean, default: false, null: false
      add :in_wednesday, :boolean, default: false, null: false
      add :in_thursday, :boolean, default: false, null: false
      add :in_friday, :boolean, default: false, null: false
      add :in_saturday, :boolean, default: false, null: false
      add :in_sunday, :boolean, default: false, null: false
    end
  end
end
