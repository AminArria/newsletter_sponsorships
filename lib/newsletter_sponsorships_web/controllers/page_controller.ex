defmodule NewsletterSponsorshipsWeb.PageController do
  use NewsletterSponsorshipsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
