defmodule SponsorlyWeb.IssueView do
  use SponsorlyWeb, :view

  def if_confirmed([], _content), do: nil
  def if_confirmed(_confirmations, content), do: content

  def if_pending([], content), do: content
  def if_pending(_confirmations, _content), do: nil
end
