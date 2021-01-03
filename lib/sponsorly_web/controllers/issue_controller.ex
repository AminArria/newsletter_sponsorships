defmodule SponsorlyWeb.IssueController do
  use SponsorlyWeb, :controller

  alias Sponsorly.Newsletters
  alias Sponsorly.Newsletters.Issue
  alias Sponsorly.Sponsorships

  plug :fetch_newsletter

  def index(conn, _params) do
    issues = Newsletters.list_issues(conn.assigns.newsletter.id)
    render(conn, "index.html", issues: issues)
  end

  def new(conn, _params) do
    changeset = Newsletters.change_issue(%Issue{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"issue" => issue_params}) do
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
      |> Sponsorly.Repo.preload(sponsorships: :user)

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

  defp fetch_newsletter(conn, _) do
    %{"newsletter_id" => newsletter_id} = conn.params
    newsletter = Newsletters.get_newsletter!(conn.assigns.current_user.id, newsletter_id)
    assign(conn, :newsletter, newsletter)
  end
end
