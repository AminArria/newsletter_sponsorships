defmodule Sponsorly.Newsletters.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "issues" do
    field :name, :string
    field :due_at, :utc_datetime
    field :deleted, :boolean, default: false

    belongs_to :newsletter, Sponsorly.Newsletters.Newsletter

    timestamps()
  end

  @doc false
  def create_changeset(issue, attrs) do
    issue
    |> cast(attrs, [:due_at, :name, :newsletter_id])
    |> validate_required([:due_at, :name, :newsletter_id])
  end

  def update_changeset(issue, attrs) do
    issue
    |> cast(attrs, [:due_at, :name])
    |> validate_required([:due_at, :name])
  end

  def soft_delete_changeset(issue) do
    change(issue, %{deleted: true})
  end
end
