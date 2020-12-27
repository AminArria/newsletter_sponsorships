defmodule SponsorlyWeb.PageControllerTest do
  use SponsorlyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Sponsorly!"
  end
end
