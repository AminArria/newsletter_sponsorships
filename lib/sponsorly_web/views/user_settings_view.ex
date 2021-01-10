defmodule SponsorlyWeb.UserSettingsView do
  use SponsorlyWeb, :view

  def active_tab(nil, :user), do: "is-active"
  def active_tab(:nil, _not_user), do: nil
  def active_tab(tab, tab), do: "is-active"
  def active_tab(_tab, _diff_tab), do: nil

  def hide_tab_target(nil, :user), do: nil
  def hide_tab_target(:nil, _not_user), do: "is-hidden"
  def hide_tab_target(tab, tab), do: nil
  def hide_tab_target(_tab, _diff_tab), do: "is-hidden"
end
