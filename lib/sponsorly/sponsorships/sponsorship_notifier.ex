defmodule Sponsorly.Sponsorships.SponsorshipNotifier do
  import Bamboo.Email
  alias SponsorlyWeb.Mailer
  alias SponsorlyWeb.Router.Helpers, as: Routes

  @from "sponsorships@sponsorly.aminarria.tech"

  @doc """
  Deliver sponsorship submitted notification.
  """
  def deliver_sponsorship_submitted(email, sponsorship) do
    email_text = sponsorship_submitted_text(email, sponsorship)

    new_email(
      to: email,
      from: @from,
      subject: "Sponsorhip Submitted",
      text_body: email_text
    )
    |> Mailer.deliver_now()
  end

  def sponsorship_submitted_text(email, %{user: nil} = sponsorship) do
    """
    ==============================

    Hi #{email},

    Your sponsorship for "#{sponsorship.issue.newsletter.name}" issue "#{sponsorship.issue.due_date}" has been submitted

    To keep track of your sponsorships you can register using this link:

    #{Routes.user_registration_url(SponsorlyWeb.Endpoint, :from_sponsorship, sponsorship, email: email)}

    Your sponsorship has the following copy text:

    #{sponsorship.copy}

    ==============================
    """
  end

  def sponsorship_submitted_text(email, sponsorship) do
    """
    ==============================

    Hi #{email},

    Your sponsorship for "#{sponsorship.issue.newsletter.name}" issue "#{sponsorship.issue.due_date}" has been submitted

    You can check your sponsorships at

    #{Routes.sponsorship_url(SponsorlyWeb.Endpoint, :index)}

    Your sponsorship has the following copy text:

    #{sponsorship.copy}

    ==============================
    """
  end

  @doc """
  Deliver confirmation of sponsorship.
  """
  def deliver_sponsorship_confirmation(email, sponsorship) do
    email_text = sponsorship_confirmation_text(email, sponsorship)

    new_email(
      to: email,
      from: @from,
      subject: "Sponsorhip Confirmed!",
      text_body: email_text
    )
    |> Mailer.deliver_now()
  end

  def sponsorship_confirmation_text(email, %{user: nil} = sponsorship) do
    """
    ==============================

    Hi #{email},

    Your sponsorship for "#{sponsorship.issue.newsletter.name}" issue "#{sponsorship.issue.due_date}" has been confirmed!

    To keep track of your sponsorships you can register using this link:

    #{Routes.user_registration_url(SponsorlyWeb.Endpoint, :from_sponsorship, sponsorship, email: email)}

    ==============================
    """
  end

  def sponsorship_confirmation_text(email, sponsorship) do
    """
    ==============================

    Hi #{email},

    Your sponsorship for "#{sponsorship.issue.newsletter.name}" issue "#{sponsorship.issue.due_date}" has been confirmed!

    You can check your sponsorships at

    #{Routes.sponsorship_url(SponsorlyWeb.Endpoint, :index)}

    ==============================
    """
  end
end
