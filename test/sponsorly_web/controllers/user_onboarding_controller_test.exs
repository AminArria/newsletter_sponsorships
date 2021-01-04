defmodule SponsorlyWeb.UserOnboardingControllerTest do
  use SponsorlyWeb.ConnCase, async: true

  import Sponsorly.AccountsFixtures

  setup :log_in_unboarded_user

  def log_in_unboarded_user(%{conn: conn}) do
    user = unboarded_user_fixture()
    conn = log_in_user(conn, user)
    %{user: user, conn: conn}
  end

  describe "GET /users/onboard" do
    test "renders the onboarding page", %{conn: conn} do
      conn = get(conn, Routes.user_onboarding_path(conn, :edit))
      response = html_response(conn, 200)
      assert response =~ "<h1>Welcome!</h1>"
    end
  end

  describe "PUT /users/onboard" do
    test "onboards the user", %{conn: conn} do
      conn = put(conn, Routes.user_onboarding_path(conn, :update), %{"user" => %{"slug" => unique_user_slug()}})

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) =~ "Welcome"

      # This extra check is because for now the page we redirect to does not
      # check if user was onboarded
      conn = get(conn, Routes.newsletter_path(conn, :index))
      assert html_response(conn, 200)
    end

    test "renders errors if data invalid", %{conn: conn} do
      conn = put(conn, Routes.user_onboarding_path(conn, :update), %{"user" => %{"slug" => "not valid"}})
      response = html_response(conn, 200)
      assert response =~ "<h1>Welcome!</h1>"
    end
  end
end
