defmodule Sponsorly.Sponsorships.ConfirmedSponsorship do
  use Ecto.Schema
  import Ecto.Changeset

  schema "confirmed_sponsorships" do
    field :copy, :string

    belongs_to :user, Sponsorly.Accounts.User
    belongs_to :issue, Sponsorly.Newsletters.Issue
    belongs_to :sponsorship, Sponsorly.Sponsorships.Sponsorship

    timestamps()
  end

  @doc false
  def create_changeset(confirmed_sponsorship, attrs) do
    confirmed_sponsorship
    |> cast(attrs, [:copy, :user_id, :issue_id, :sponsorship_id])
    |> validate_required([:copy, :user_id, :issue_id, :sponsorship_id])
  end

  def update_changeset(confirmed_sponsorship, attrs) do
    confirmed_sponsorship
    |> cast(attrs, [:copy])
    |> validate_required([:copy])
  end
end
