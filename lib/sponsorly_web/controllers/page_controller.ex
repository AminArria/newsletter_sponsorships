defmodule SponsorlyWeb.PageController do
  use SponsorlyWeb, :controller

  def index(conn, _params) do
    case conn.assigns.current_user do
      nil -> render(conn, "index.html")
      _user -> redirect(conn, to: Routes.page_path(conn, :dashboard))
    end

  end

  def dashboard(conn, _params) do
    render(conn, "dashboard.html")
  end
end
