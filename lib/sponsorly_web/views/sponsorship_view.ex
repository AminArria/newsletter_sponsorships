defmodule SponsorlyWeb.SponsorshipView do
  use SponsorlyWeb, :view

  def issue_name(%{name: nil} = issue) do
    issue.due_at
    |> DateTime.to_date()
    |> to_string()
  end

  def issue_name(issue) do
    issue.name
  end

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
