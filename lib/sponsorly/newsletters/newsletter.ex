defmodule Sponsorly.Newsletters.Newsletter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "newsletters" do
    field :deleted, :boolean, default: false
    field :interval_days, :integer
    field :name, :string
    field :slug, :string
    field :sponsor_before_days, :integer
    field :sponsor_in_days, :integer

    field :next_issue, :date, virtual: true

    belongs_to :user, Sponsorly.Accounts.User
    has_many :issues, Sponsorly.Newsletters.Issue

    timestamps()
  end

  @doc false
  def create_changeset(newsletter, attrs) do
    newsletter
    |> cast(attrs, [:name, :interval_days, :next_issue, :slug, :sponsor_before_days, :sponsor_in_days, :user_id])
    |> validate_required([:name, :interval_days, :next_issue, :slug, :sponsor_before_days, :sponsor_in_days, :user_id])
    |> common_validations()
    |> validate_next_issue()
    |> prepare_changes(&generate_issues/1)
  end

  defp validate_next_issue(changeset) do
    with next_issue when not is_nil(next_issue) <- get_change(changeset, :next_issue),
         :gt <- Date.compare(next_issue, Date.utc_today()) do
      changeset
    else
      _ ->
        add_error(changeset, :next_issue, "must be after today")
    end
  end

  defp generate_issues(changeset) do
    next_issue = get_change(changeset, :next_issue)
    interval_days = get_change(changeset, :interval_days)
    sponsor_in_days = get_change(changeset, :sponsor_in_days)
    max_sponsor_at = Date.add(Date.utc_today(), sponsor_in_days)

    issues_attrs = generate_issues(next_issue, max_sponsor_at, interval_days, [])
    put_change(changeset, :issues, issues_attrs)
  end

  def generate_issues(current_issue_at, max_sponsor_at, interval_days, issues_attrs) do
    case Date.compare(max_sponsor_at, current_issue_at) do
      :gt ->
        issue_attrs = %{due_at: DateTime.new!(current_issue_at, ~T[11:00:00])}
        next_issue = Date.add(current_issue_at, interval_days)
        generate_issues(next_issue, max_sponsor_at, interval_days, issues_attrs ++ [issue_attrs])

      _ ->
        issues_attrs
    end
  end

  def update_changeset(newsletter, attrs) do
    newsletter
    |> cast(attrs, [:name, :interval_days, :slug, :sponsor_before_days, :sponsor_in_days])
    |> validate_required([:name, :interval_days, :slug, :sponsor_before_days, :sponsor_in_days])
    |> common_validations()
  end

  defp common_validations(changeset) do
    changeset
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/, message: "must only contain lowercase characters (a-z), numbers (0-9), and \"-\"")
    |> unique_constraint([:slug, :user_id])
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
