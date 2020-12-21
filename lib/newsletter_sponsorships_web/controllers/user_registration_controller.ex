defmodule NewsletterSponsorshipsWeb.UserRegistrationController do
  use NewsletterSponsorshipsWeb, :controller

  alias NewsletterSponsorships.Accounts
  alias NewsletterSponsorships.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        Accounts.deliver_user_confirmation_instructions(user, &Routes.user_confirmation_url(conn, :confirm, &1))

        conn
        |> put_flash(:info, "User created successfully. Please confirm your email to log in.")
        |> redirect(to: Routes.user_session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
