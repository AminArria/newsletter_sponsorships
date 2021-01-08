defmodule SponsorlyWeb.UserRegistrationController do
  use SponsorlyWeb, :controller

  alias Sponsorly.Accounts
  alias Sponsorly.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        Accounts.deliver_user_confirmation_instructions(user, &Routes.user_confirmation_url(conn, :confirm, &1))
        Sponsorly.Sponsorships.link_sponsorships_to_user(user)

        conn
        |> put_flash(:info, "User created successfully. Please confirm your email to log in.")
        |> redirect(to: Routes.user_session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def from_sponsorship(conn, %{"sponsorship_id" => sponsorship_id, "email" => email}) do
    sponsorship = Sponsorly.Sponsorships.get_sponsorship_by_email_and_id!(sponsorship_id, email)
    changeset = Accounts.change_user_registration(%User{email: email})
    render(conn, "from_sponsorship.html", changeset: changeset, sponsorship: sponsorship)
  end
end
