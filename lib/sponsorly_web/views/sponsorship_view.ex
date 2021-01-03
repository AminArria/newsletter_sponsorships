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
end
