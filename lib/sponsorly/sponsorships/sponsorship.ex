defmodule Sponsorly.Sponsorships.Sponsorship do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sponsorships" do
    field :copy, :string
    field :deleted, :boolean, default: false

    belongs_to :user, Sponsorly.Accounts.User
    belongs_to :issue, Sponsorly.Newsletters.Issue

    timestamps()
  end

  @doc false
  def create_changeset(sponsorship, attrs) do
    sponsorship
    |> cast(attrs, [:copy, :user_id, :issue_id])
    |> validate_required([:copy, :user_id, :issue_id])
  end

  def update_changeset(sponsorship, attrs) do
    sponsorship
    |> cast(attrs, [:copy])
    |> validate_required([:copy])
  end

  def soft_delete_changeset(sponsorship) do
    change(sponsorship, %{deleted: true})
  end
end
