defmodule SponsorlyWeb.ConfirmedSponsorshipController do
  use SponsorlyWeb, :controller

  alias Sponsorly.Sponsorships

  def create(conn, %{"confirmed_sponsorship" => %{"issue_id" => issue_id, "sponsorship_id" => sponsorship_id}}) do
    sponsorship = Sponsorships.get_sponsorship_for_issue!(issue_id, sponsorship_id)
    confirmed_sponsorship_params = %{
      copy: sponsorship.copy,
      sponsorship_id: sponsorship.id,
      issue_id: sponsorship.issue_id,
      user_id: sponsorship.user_id
    }

    {:ok, _confirmed_sponsorship} = Sponsorships.create_confirmed_sponsorship(confirmed_sponsorship_params)

    conn
    |> put_flash(:info, "Sponsorship confirmed successfully.")
    |> redirect(to: Routes.newsletter_issue_path(conn, :show, sponsorship.issue.newsletter_id, sponsorship.issue))
  end

  def edit(conn, %{"id" => id}) do
    confirmed_sponsorship = Sponsorships.get_confirmed_sponsorship!(id)
    changeset = Sponsorships.change_confirmed_sponsorship(confirmed_sponsorship)
    render(conn, "edit.html", confirmed_sponsorship: confirmed_sponsorship, changeset: changeset)
  end

  def update(conn, %{"id" => id, "confirmed_sponsorship" => confirmed_sponsorship_params}) do
    confirmed_sponsorship = Sponsorships.get_confirmed_sponsorship!(id)

    {:ok, _confirmed_sponsorship} = Sponsorships.update_confirmed_sponsorship(confirmed_sponsorship, confirmed_sponsorship_params)

    conn
    |> put_flash(:info, "Sponsorship copy updated successfully.")
    |> redirect(to: Routes.newsletter_issue_path(conn, :show, confirmed_sponsorship.issue.newsletter_id, confirmed_sponsorship.issue))
  end

  def delete(conn, %{"id" => id}) do
    confirmed_sponsorship = Sponsorships.get_confirmed_sponsorship!(id)
    {:ok, _confirmed_sponsorship} = Sponsorships.delete_confirmed_sponsorship(confirmed_sponsorship)

    conn
    |> put_flash(:info, "Cancelled sponsorship successfully.")
    |> redirect(to: Routes.newsletter_issue_path(conn, :show, confirmed_sponsorship.issue.newsletter_id, confirmed_sponsorship.issue))
  end
end
