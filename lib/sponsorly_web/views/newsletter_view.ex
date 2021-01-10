defmodule SponsorlyWeb.NewsletterView do
  use SponsorlyWeb, :view

  def in_day_field(form, field, name) do
    ~E"""
    <%= checkbox form, field, class: "is-hidden" %>
    <%= label form, field, name, class: "button checkbox-toggle mt-2" %>
    """
  end

  def days_ul(newsletter) do
    days =
      Sponsorly.Newsletters.Newsletter.in_days()
      |> Enum.map(fn in_day ->
        if Map.get(newsletter, in_day) do
          day_from_field(in_day)
        end
      end)
      |> Enum.filter(& &1)

    ~E"""
    <ul>
      <%= for day <- days do %>
        <li><%= day %></li>
      <% end %>
    </ul>
    """
  end

  defp day_from_field(:in_monday), do: "Monday"
  defp day_from_field(:in_tuesday), do: "Tuesday"
  defp day_from_field(:in_wednesday), do: "Wednesday"
  defp day_from_field(:in_thursday), do: "Thursday"
  defp day_from_field(:in_friday), do: "Friday"
  defp day_from_field(:in_saturday), do: "Saturday"
  defp day_from_field(:in_sunday), do: "Sunday"
end
