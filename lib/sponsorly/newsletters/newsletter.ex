defmodule Sponsorly.Newsletters.Newsletter do
  use Ecto.Schema
  import Ecto.Changeset
  require IEx

  schema "newsletters" do
    field :deleted, :boolean, default: false
    field :name, :string
    field :slug, :string
    field :sponsor_before_days, :integer
    field :sponsor_in_days, :integer
    field :in_monday, :boolean, default: false
    field :in_tuesday, :boolean, default: false
    field :in_wednesday, :boolean, default: false
    field :in_thursday, :boolean, default: false
    field :in_friday, :boolean, default: false
    field :in_saturday, :boolean, default: false
    field :in_sunday, :boolean, default: false

    field :next_issue, :date, virtual: true

    belongs_to :user, Sponsorly.Accounts.User
    has_many :issues, Sponsorly.Newsletters.Issue

    timestamps()
  end

  @in_days [:in_monday, :in_tuesday, :in_wednesday, :in_thursday, :in_friday, :in_saturday, :in_sunday]
  def in_days, do: @in_days

  @doc false
  def create_changeset(newsletter, attrs) do
    newsletter
    |> cast(attrs, [:name, :next_issue, :slug, :sponsor_before_days, :sponsor_in_days, :user_id] ++ @in_days)
    |> validate_required([:name, :next_issue, :slug, :sponsor_before_days, :sponsor_in_days, :user_id] ++ @in_days)
    |> common_validations()
    |> validate_next_issue()
    |> prepare_changes(&generate_issues/1)
  end

  defp validate_next_issue(changeset) do
    with next_issue when not is_nil(next_issue) <- get_change(changeset, :next_issue),
         :gt <- Date.compare(next_issue, Date.utc_today()),
         weekday <- Date.day_of_week(next_issue),
         in_day_field <- Enum.at(@in_days, weekday - 1),
         true <- get_change(changeset, in_day_field, false) do
      changeset
    else
      false ->
        add_error(changeset, :next_issue, "is not in any of the days you publish")

      _lt_eq ->
        add_error(changeset, :next_issue, "must be after today")
    end
  end

  defp generate_issues(changeset) do
    next_issue = get_change(changeset, :next_issue)
    sponsor_in_days = get_change(changeset, :sponsor_in_days)
    max_sponsor_date = Date.add(Date.utc_today(), sponsor_in_days)

    days_check =
      Enum.with_index(@in_days)
      |> Enum.reduce(%{}, fn {day, index}, acc ->
        in_day = get_change(changeset, day, false)
        # Because Enum.with_index/2 starts at 0, but Date.day_of_week/1 starts at 1
        day_index = index + 1
        Map.put(acc, day_index, in_day)
      end)

    issues_attrs = generate_issues(next_issue, max_sponsor_date, days_check, [])
    put_change(changeset, :issues, issues_attrs)
  end

  def generate_issues(current_date, max_sponsor_date, days_check, issues_attrs) do
    if Date.compare(current_date, max_sponsor_date) == :lt do
      weekday = Date.day_of_week(current_date)
      next_date = Date.add(current_date, 1)

      if days_check[weekday] do
        issue_attrs = %{due_date: current_date}
        generate_issues(next_date, max_sponsor_date, days_check, issues_attrs ++ [issue_attrs])
      else
        generate_issues(next_date, max_sponsor_date, days_check, issues_attrs)
      end

    else
      issues_attrs
    end
  end

  def update_changeset(newsletter, attrs) do
    newsletter
    |> cast(attrs, [:name, :slug, :sponsor_before_days, :sponsor_in_days] ++ @in_days)
    |> validate_required([:name, :slug, :sponsor_before_days, :sponsor_in_days] ++ @in_days)
    |> common_validations()
  end

  defp common_validations(changeset) do
    changeset
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/, message: "must only contain lowercase characters (a-z), numbers (0-9), and \"-\"")
    |> unique_constraint([:slug, :user_id])
    # Can't sponsor after publishing
    |> validate_number(:sponsor_before_days, greater_than_or_equal_to: 0)
    # TODO: Indefinite amount of issues to show ahead (for now 1 year ahead max)
    |> validate_number(:sponsor_in_days, less_than_or_equal_to: 365)
  end

  def soft_delete_changeset(newsletter) do
    change(newsletter, %{deleted: true, slug: nil})
  end
end
