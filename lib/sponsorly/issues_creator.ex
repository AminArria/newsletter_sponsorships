defmodule Sponsorly.IssuesCreator do
  use GenServer

  import Ecto.Query, warn: false

  alias Sponsorly.Repo
  alias Sponsorly.Newsletters.Issue


  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  # Callbacks
  @impl true
  def init(_args) do
    Process.send_after(self(), :create_issues, 12 * 60 * 60 * 1000)
    {:ok, %{}}
  end

  @impl true
  def handle_call(_msg, _from, state) do
    {:noreply, state}
  end

  @impl true
  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info(:create_issues, state) do
    current_date = Date.utc_today()

    q =
      from i in Issue,
      where: not i.deleted,
      distinct: i.newsletter_id,
      order_by: [desc: i.due_date]

    last_issues =
      Repo.all(q)
      |> Repo.preload([:newsletter])

    new_issues =
      Enum.reduce(last_issues, [], fn issue, new_issues ->
        next_issue_date = Date.add(issue.due_date, issue.newsletter.interval_days)
        max_sponsor_date = Date.add(current_date, issue.newsletter.sponsor_in_days)
        case Date.compare(max_sponsor_date, next_issue_date) do
          :gt ->
            naive_current_at = NaiveDateTime.new(current_date, Time.utc_now())
            attrs = %{due_date: next_issue_date, newsletter_id: issue.newsletter_id, inserted_at: naive_current_at, updated_at: naive_current_at}
            [attrs | new_issues]

          _ ->
            new_issues
        end
      end)

    Repo.insert_all(Issue, new_issues)
    {:noreply, state}
  end
end
