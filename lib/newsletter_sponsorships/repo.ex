defmodule NewsletterSponsorships.Repo do
  use Ecto.Repo,
    otp_app: :newsletter_sponsorships,
    adapter: Ecto.Adapters.Postgres
end
