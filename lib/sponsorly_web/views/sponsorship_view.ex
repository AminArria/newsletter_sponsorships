defmodule SponsorlyWeb.SponsorshipView do
  use SponsorlyWeb, :view

  def if_confirmed([], _content), do: nil
  def if_confirmed(_confirmations, content), do: content

  def if_pending([], content), do: content
  def if_pending(_confirmations, _content), do: nil

  def sponsorship_email(%Sponsorly.Sponsorships.Sponsorship{user: nil, email: email}) do
    email
  end

  def sponsorship_email(%Sponsorly.Sponsorships.Sponsorship{user: user}) do
    user.email
  end

  def sponsorship_email(%Sponsorly.Sponsorships.ConfirmedSponsorship{sponsorship: sponsorship}) do
    sponsorship_email(sponsorship)
  end
end
