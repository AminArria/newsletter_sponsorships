defmodule SponsorlyWeb.UserOnboardingController do
  use SponsorlyWeb, :controller

  alias Sponsorly.Accounts

  def edit(conn, _) do
    changeset = Accounts.change_user_onboard(conn.assigns.current_user)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    case Accounts.onboard_user(conn.assigns.current_user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Welcome")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
