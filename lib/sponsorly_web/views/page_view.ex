defmodule SponsorlyWeb.PageView do
  use SponsorlyWeb, :view

  def hero_subtitle_text(%{is_creator: true, is_sponsor: true}) do
    "Manage sponsorships for your newsletter and sponsor other newsletters!"
  end

  def hero_subtitle_text(%{is_creator: true}) do
    "Manage sponsorships for your newsletter!"
  end

  def hero_subtitle_text(%{is_sponsor: true}) do
    "Sponsor newsletters!"
  end

  def hero_subtitle_text(_) do
    "Huh? Seems your account is misconfigured. Check your settings and tell us if you are a Creator and/or a Sponsor"
  end
end
