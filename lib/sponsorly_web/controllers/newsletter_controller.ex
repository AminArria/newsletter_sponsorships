defmodule SponsorlyWeb.NewsletterController do
  use SponsorlyWeb, :controller

  alias Sponsorly.Newsletters
  alias Sponsorly.Newsletters.Newsletter

  def index(conn, _params) do
    newsletters = Newsletters.list_newsletters(conn.assigns.current_user.id)
    render(conn, "index.html", newsletters: newsletters)
  end

  def new(conn, _params) do
    changeset = Newsletters.change_newsletter(%Newsletter{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"newsletter" => newsletter_params}) do
    newsletter_params = Map.put(newsletter_params, "user_id", conn.assigns.current_user.id)

    case Newsletters.create_newsletter(newsletter_params) do
      {:ok, newsletter} ->
        conn
        |> put_flash(:info, "Newsletter created successfully.")
        |> redirect(to: Routes.newsletter_path(conn, :show, newsletter))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    newsletter = Newsletters.get_newsletter!(conn.assigns.current_user.id, id)
    render(conn, "show.html", newsletter: newsletter)
  end

  def edit(conn, %{"id" => id}) do
    newsletter = Newsletters.get_newsletter!(conn.assigns.current_user.id, id)
    changeset = Newsletters.change_newsletter(newsletter)
    render(conn, "edit.html", newsletter: newsletter, changeset: changeset)
  end

  def update(conn, %{"id" => id, "newsletter" => newsletter_params}) do
    newsletter = Newsletters.get_newsletter!(conn.assigns.current_user.id, id)

    case Newsletters.update_newsletter(newsletter, newsletter_params) do
      {:ok, newsletter} ->
        conn
        |> put_flash(:info, "Newsletter updated successfully.")
        |> redirect(to: Routes.newsletter_path(conn, :show, newsletter))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", newsletter: newsletter, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    newsletter = Newsletters.get_newsletter!(conn.assigns.current_user.id, id)
    {:ok, _newsletter} = Newsletters.soft_delete_newsletter(newsletter)

    conn
    |> put_flash(:info, "Newsletter deleted successfully.")
    |> redirect(to: Routes.newsletter_path(conn, :index))
  end
end
