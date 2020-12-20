defmodule NewsletterSponsorshipsWeb.UserSessionController do
  use NewsletterSponsorshipsWeb, :controller

  alias NewsletterSponsorships.Accounts
  alias NewsletterSponsorshipsWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        render(conn, "new.html", error_message: "Invalid email or password")
      %{confirmed_at: nil} ->
        conn
        |> put_flash(:error, "You must confirm your email to log in")
        |> redirect(to: Routes.user_confirmation_path(conn, :new))
      user ->
        UserAuth.log_in_user(conn, user, user_params)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
