defmodule Sponsorly.Newsletters.Newsletter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "newsletters" do
    field :interval_days, :integer
    field :name, :string
    field :sponsor_before_days, :integer
    field :sponsor_in_days, :integer
    field :deleted, :boolean, default: false

    belongs_to :user, Sponsorly.Accounts.User

    timestamps()
  end

  @doc false
  def create_changeset(newsletter, attrs) do
    newsletter
    |> cast(attrs, [:name, :interval_days, :sponsor_before_days, :sponsor_in_days, :user_id])
    |> validate_required([:name, :interval_days, :sponsor_before_days, :sponsor_in_days, :user_id])
    |> common_validations()
  end

  def update_changeset(newsletter, attrs) do
    newsletter
    |> cast(attrs, [:name, :interval_days, :sponsor_before_days, :sponsor_in_days])
    |> validate_required([:name, :interval_days, :sponsor_before_days, :sponsor_in_days])
    |> common_validations()
  end

  defp common_validations(changeset) do
    changeset
    # TODO: allow publishing more than once a day
    |> validate_number(:interval_days, greater_than_or_equal_to: 1, less_than_or_equal_to: 7)
    # Can't sponsor after publishing
    |> validate_number(:sponsor_before_days, greater_than_or_equal_to: 0)
    # TODO: Indefinite amount of issues to show ahead (for now 1 year ahead max)
    |> validate_number(:sponsor_in_days, less_than_or_equal_to: 365)
  end

  def soft_delete_changeset(newsletter) do
    change(newsletter, %{deleted: true})
  end
end
