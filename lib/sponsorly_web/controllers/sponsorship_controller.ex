defmodule SponsorlyWeb.SponsorshipController do
  use SponsorlyWeb, :controller

  alias Sponsorly.Newsletters
  alias Sponsorly.Sponsorships
  alias Sponsorly.Sponsorships.Sponsorship

  def index(conn, _params) do
    sponsorships = Sponsorships.list_sponsorships(conn.assigns.current_user.id)
    render(conn, "index.html", sponsorships: sponsorships)
  end

  def new(conn, _params) do
    changeset = Sponsorships.change_sponsorship(%Sponsorship{})
    issues = Newsletters.list_issues()
    render(conn, "new.html", changeset: changeset, issues: issues)
  end

  def create(conn, %{"sponsorship" => sponsorship_params}) do
    sponsorship_params = Map.put(sponsorship_params, "user_id", conn.assigns.current_user.id)

    case Sponsorships.create_sponsorship(sponsorship_params) do
      {:ok, sponsorship} ->
        conn
        |> put_flash(:info, "Sponsorship created successfully.")
        |> redirect(to: Routes.sponsorship_path(conn, :show, sponsorship))

      {:error, %Ecto.Changeset{} = changeset} ->
        issues = Newsletters.list_issues()
        render(conn, "new.html", changeset: changeset, issues: issues)
    end
  end

  def show(conn, %{"id" => id}) do
    sponsorship = Sponsorships.get_sponsorship!(conn.assigns.current_user.id, id)
    render(conn, "show.html", sponsorship: sponsorship)
  end

  def edit(conn, %{"id" => id}) do
    sponsorship = Sponsorships.get_sponsorship!(conn.assigns.current_user.id, id)
    changeset = Sponsorships.change_sponsorship(sponsorship)
    render(conn, "edit.html", sponsorship: sponsorship, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sponsorship" => sponsorship_params}) do
    sponsorship = Sponsorships.get_sponsorship!(conn.assigns.current_user.id, id)

    case Sponsorships.update_sponsorship(sponsorship, sponsorship_params) do
      {:ok, sponsorship} ->
        conn
        |> put_flash(:info, "Sponsorship updated successfully.")
        |> redirect(to: Routes.sponsorship_path(conn, :show, sponsorship))

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
