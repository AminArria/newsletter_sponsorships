defmodule Sponsorly.Newsletters.Newsletter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "newsletters" do
    field :interval_days, :integer
    field :name, :string
    field :sponsor_before_days, :integer
    field :sponsor_in_days, :integer
    field :deleted, :boolean, default: false

    field :next_issue_at, :utc_datetime, virtual: true

    belongs_to :user, Sponsorly.Accounts.User
    has_many :issues, Sponsorly.Newsletters.Issue

    timestamps()
  end

  @doc false
  def create_changeset(newsletter, attrs) do
    newsletter
    |> cast(attrs, [:name, :interval_days, :next_issue_at, :sponsor_before_days, :sponsor_in_days, :user_id])
    |> validate_required([:name, :interval_days, :next_issue_at, :sponsor_before_days, :sponsor_in_days, :user_id])
    |> common_validations()
    |> validate_next_issue()
    |> prepare_changes(&generate_issues/1)
  end

  defp validate_next_issue(changeset) do
    with next_issue_at when not is_nil(next_issue_at) <- get_change(changeset, :next_issue_at),
         :gt <- DateTime.compare(next_issue_at, DateTime.utc_now()) do
      changeset
    else
      _ ->
        add_error(changeset, :next_issue_at, "must be after today")
    end
  end

  defp generate_issues(changeset) do
    next_issue_at = get_change(changeset, :next_issue_at)
    interval_days = get_change(changeset, :interval_days)
    sponsor_in_days = get_change(changeset, :sponsor_in_days)
    max_sponsor_at = DateTime.add(next_issue_at, sponsor_in_days * 24 * 60 * 60)

    issues_attrs = generate_issues(next_issue_at, max_sponsor_at, interval_days, [])
    put_change(changeset, :issues, issues_attrs)
  end

  def generate_issues(current_issue_at, max_sponsor_at, interval_days, issues_attrs) do
    case DateTime.compare(max_sponsor_at, current_issue_at) do
      :gt ->
        issue_attrs = %{due_at: current_issue_at}
        next_issue_at = DateTime.add(current_issue_at, interval_days * 24 * 60 * 60)
        generate_issues(next_issue_at, max_sponsor_at, interval_days, issues_attrs ++ [issue_attrs])

      _ ->
        issues_attrs
    end
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
