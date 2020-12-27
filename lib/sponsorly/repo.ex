defmodule Sponsorly.Repo do
  use Ecto.Repo,
    otp_app: :sponsorly,
    adapter: Ecto.Adapters.Postgres
end
