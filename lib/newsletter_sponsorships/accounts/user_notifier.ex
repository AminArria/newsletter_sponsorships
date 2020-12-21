defmodule NewsletterSponsorships.Accounts.UserNotifier do
  import Bamboo.Email
  alias NewsletterSponsorshipsWeb.Mailer

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    email_text =
      """
      ==============================

      Hi #{user.email},

      You can confirm your account by visiting the URL below:

      #{url}

      If you didn't create an account with us, please ignore this.

      ==============================
      """

    new_email(
      to: user.email,
      from: "no-reply@newsletter-sponsorships.com",
      subject: "Email Confirmation",
      text_body: email_text
    )
    |> Mailer.deliver_now()
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    email_text = """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """

    new_email(
      to: user.email,
      from: "no-reply@newsletter-sponsorships.com",
      subject: "Password Reset",
      text_body: email_text
    )
    |> Mailer.deliver_now()
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    email_text = """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """

    new_email(
      to: user.email,
      from: "no-reply@newsletter-sponsorships.com",
      subject: "Update Email",
      text_body: email_text
    )
    |> Mailer.deliver_now()
  end
end
