defmodule SponsorlyWeb.IssueController do
  use SponsorlyWeb, :controller

  alias Sponsorly.Newsletters
  alias Sponsorly.Newsletters.Issue
  alias Sponsorly.Sponsorships

  plug :fetch_newsletter when action not in [:slug_index]

  def index(conn, _params) do
    confirmed_issues = Newsletters.list_confirmed_issues(conn.assigns.newsletter.id)
    pending_issues = Newsletters.list_pending_issues(conn.assigns.newsletter.id)
    past_issues = Newsletters.list_past_issues(conn.assigns.newsletter.id)
    render(conn, "index.html", confirmed_issues: confirmed_issues, pending_issues: pending_issues, past_issues: past_issues)
  end

  def new(conn, _params) do
    changeset = Newsletters.change_issue(%Issue{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"issue" => issue_params}) do
    issue_params = Map.put(issue_params, "newsletter_id", conn.assigns.newsletter.id)

    case Newsletters.create_issue(issue_params) do
      {:ok, issue} ->
        conn
        |> put_flash(:info, "Issue created successfully.")
        |> redirect(to: Routes.newsletter_issue_path(conn, :show, conn.assigns.newsletter, issue))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    issue =
      Newsletters.get_issue!(conn.assigns.newsletter.id, id)
      |> Sponsorly.Repo.preload(confirmed_sponsorship: [sponsorship: :user])

    sponsorships = Sponsorships.list_sponsorships_for_issue(issue.id)
    render(conn, "show.html", issue: issue, sponsorships: sponsorships)
  end

  def edit(conn, %{"id" => id}) do
    issue = Newsletters.get_issue!(conn.assigns.newsletter.id, id)
    changeset = Newsletters.change_issue(issue)
    render(conn, "edit.html", issue: issue, changeset: changeset)
  end

  def update(conn, %{"id" => id, "issue" => issue_params}) do
    issue = Newsletters.get_issue!(conn.assigns.newsletter.id, id)

    case Newsletters.update_issue(issue, issue_params) do
      {:ok, issue} ->
        conn
        |> put_flash(:info, "Issue updated successfully.")
        |> redirect(to: Routes.newsletter_issue_path(conn, :show, conn.assigns.newsletter, issue))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", issue: issue, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    issue = Newsletters.get_issue!(conn.assigns.newsletter.id, id)
    {:ok, _issue} = Newsletters.soft_delete_issue(issue)

    conn
    |> put_flash(:info, "Issue deleted successfully.")
    |> redirect(to: Routes.newsletter_issue_path(conn, :index, conn.assigns.newsletter))
  end

  def slug_index(conn, %{"user_slug" => user_slug, "newsletter_slug" => newsletter_slug}) do
    changeset = Sponsorly.Sponsorships.change_sponsorship(%Sponsorly.Sponsorships.Sponsorship{})
    newsletter = Newsletters.get_newsletter_by_slugs!(user_slug, newsletter_slug)
    issues = Newsletters.list_issues_of_slugs(user_slug, newsletter_slug)
    render(conn, "slug_index.html", newsletter: newsletter, issues: issues, changeset: changeset)
  end

  defp fetch_newsletter(conn, _) do
    %{"newsletter_id" => newsletter_id} = conn.params
    newsletter = Newsletters.get_newsletter!(conn.assigns.current_user.id, newsletter_id)
    assign(conn, :newsletter, newsletter)
  end
end
