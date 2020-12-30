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
    current_at = DateTime.utc_now()

    q =
      from i in Issue,
      where: not i.deleted,
      distinct: i.newsletter_id,
      order_by: [desc: i.due_at]

    last_issues =
      Repo.all(q)
      |> Repo.preload([:newsletter])

    new_issues =
      Enum.reduce(last_issues, [], fn issue, new_issues ->
        next_issue_at = DateTime.add(issue.due_at, issue.newsletter.interval_days * 24 * 60 * 60)
        max_sponsor_at = DateTime.add(current_at, issue.newsletter.sponsor_in_days * 24 * 60 * 60)
        case DateTime.compare(max_sponsor_at, next_issue_at) do
          :gt ->
            naive_current_at = DateTime.to_naive(current_at) |> NaiveDateTime.truncate(:second)
            attrs = %{due_at: next_issue_at, newsletter_id: issue.newsletter_id, inserted_at: naive_current_at, updated_at: naive_current_at}
            [attrs | new_issues]

          _ ->
            new_issues
        end
      end)

    Repo.insert_all(Issue, new_issues)
    {:noreply, state}
  end
end
