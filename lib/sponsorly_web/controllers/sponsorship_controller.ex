defmodule SponsorlyWeb.SponsorshipController do
  use SponsorlyWeb, :controller

  alias Sponsorly.Newsletters
  alias Sponsorly.Sponsorships

  def index(conn, _params) do
    confirmed_sponsorships = Sponsorships.list_confirmed_sponsorships(conn.assigns.current_user.id)
    pending_sponsorships = Sponsorships.list_pending_sponsorships(conn.assigns.current_user.id)
    past_sponsorships = Sponsorships.list_past_sponsorships(conn.assigns.current_user.id)
    render(conn, "index.html", confirmed_sponsorships: confirmed_sponsorships, pending_sponsorships: pending_sponsorships, past_sponsorships: past_sponsorships)
  end

  def create(%{assigns: %{current_user: nil}} = conn, %{"sponsorship" => sponsorship_params}) do
    case Sponsorships.create_sponsorship(sponsorship_params) do
      {:ok, sponsorship} ->
        conn
        |> put_flash(:info, "Sponsorship created successfully.")
        |> redirect(to: Routes.user_registration_path(conn, :from_sponsorship, sponsorship, email: sponsorship.email))

      {:error, %Ecto.Changeset{} = changeset} ->
        issues = Newsletters.list_issues()
        render(conn, "new.html", changeset: changeset, issues: issues)
    end
  end

  def create(%{assigns: %{current_user: current_user}} = conn, %{"sponsorship" => sponsorship_params}) do
    sponsorship_params = Map.put(sponsorship_params, "user_id", current_user.id)

    case Sponsorships.create_sponsorship(sponsorship_params) do
      {:ok, _sponsorship} ->
        conn
        |> put_flash(:info, "Sponsorship created successfully.")
        |> redirect(to: Routes.sponsorship_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        issues = Newsletters.list_issues()
        render(conn, "new.html", changeset: changeset, issues: issues)
    end
  end

  def edit(conn, %{"id" => id}) do
    sponsorship = Sponsorships.get_sponsorship!(conn.assigns.current_user.id, id)
    changeset = Sponsorships.change_sponsorship(sponsorship)
    render(conn, "edit.html", sponsorship: sponsorship, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sponsorship" => sponsorship_params}) do
    sponsorship = Sponsorships.get_sponsorship!(conn.assigns.current_user.id, id)

    case Sponsorships.update_sponsorship(sponsorship, sponsorship_params) do
      {:ok, _sponsorship} ->
        conn
        |> put_flash(:info, "Sponsorship updated successfully.")
        |> redirect(to: Routes.sponsorship_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", sponsorship: sponsorship, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sponsorship = Sponsorships.get_sponsorship!(conn.assigns.current_user.id, id)
    {:ok, _sponsorship} = Sponsorships.soft_delete_sponsorship(sponsorship)

    conn
    |> put_flash(:info, "Sponsorship deleted successfully.")
    |> redirect(to: Routes.sponsorship_path(conn, :index))
  end
end
