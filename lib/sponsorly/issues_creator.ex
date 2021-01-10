defmodule Sponsorly.IssuesCreator do
  use GenServer

  import Ecto.Query, warn: false

  alias Sponsorly.Repo
  alias Sponsorly.Newsletters.Issue
  alias Sponsorly.Newsletters.Newsletter


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
    Process.send_after(self(), :create_issues, 12 * 60 * 60 * 1000)

    generate_issues()

    {:noreply, state}
  end

  def generate_issues do
    today = Date.utc_today()
    weekday = Date.day_of_week(today)
    in_day_field = Enum.at(Newsletter.in_days(), weekday - 1)

    newsletters_today_q =
      from n in Newsletter,
        select: n.id,
        where: field(n, ^in_day_field) and
               not n.deleted

    already_issued_q =
      from i in Issue,
        select: i.newsletter_id,
        where: i.due_date == ^today and
               not i.deleted

    already_issued = Repo.all(already_issued_q)
    pending_for_issue =
      Repo.all(newsletters_today_q)
      |> Enum.reject(fn newsletter_id -> newsletter_id in already_issued end)

    new_issues =
      Enum.map(pending_for_issue, fn newsletter_id ->
        naive_current_at = NaiveDateTime.new!(today, Time.utc_now()) |> NaiveDateTime.truncate(:second)
        %{due_date: today, newsletter_id: newsletter_id, inserted_at: naive_current_at, updated_at: naive_current_at}
      end)

    Repo.insert_all(Issue, new_issues)
  end
end
