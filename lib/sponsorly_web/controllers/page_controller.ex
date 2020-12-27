defmodule SponsorlyWeb.PageController do
  use SponsorlyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
