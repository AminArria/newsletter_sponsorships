defmodule Sponsorly.Sponsorships.Sponsorship do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sponsorships" do
    field :copy, :string
    field :deleted, :boolean, default: false
    field :email, :string

    belongs_to :user, Sponsorly.Accounts.User
    belongs_to :issue, Sponsorly.Newsletters.Issue
    has_one :confirmed_sponsorship, Sponsorly.Sponsorships.ConfirmedSponsorship

    timestamps()
  end

  @doc false
  def create_changeset(sponsorship, attrs) do
    sponsorship
    |> cast(attrs, [:copy, :email, :user_id, :issue_id])
    |> validate_required([:copy, :issue_id])
    |> validate_user_or_email()
  end

  defp validate_user_or_email(changeset) do
    case get_change(changeset, :user_id) do
      nil ->
        changeset
        |> validate_required([:email])
        |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
        |> validate_length(:email, max: 160)

      _user_id ->
        changeset
        |> validate_required([:user_id])
        |> delete_change(:email)
    end
  end

  def update_changeset(sponsorship, attrs) do
    sponsorship
    |> cast(attrs, [:copy])
    |> validate_required([:copy])
  end

  def soft_delete_changeset(sponsorship) do
    change(sponsorship, %{deleted: true})
  end

  def link_user_changeset(sponsorship, attrs) do
    sponsorship
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
