defmodule SponsorlyWeb.SponsorshipControllerTest do
  use SponsorlyWeb.ConnCase, async: true

  setup :register_and_log_in_user

  @invalid_attrs %{copy: nil}

  describe "index" do
    setup :create_sponsorship

    test "lists all sponsorships of user", %{conn: conn, sponsorship: sponsorship} do
      other_sponsorship = insert(:sponsorship)

      conn = get(conn, Routes.sponsorship_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ sponsorship.issue.newsletter.name
      assert response =~ sponsorship.issue.name
      refute response =~ other_sponsorship.issue.newsletter.name
      refute response =~ other_sponsorship.issue.name
    end
  end

  describe "new sponsorship" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.sponsorship_path(conn, :new))
      assert html_response(conn, 200) =~ "New Sponsorship"
    end
  end

  describe "create sponsorship" do
    test "redirects to show when data is valid", %{conn: conn} do
      issue = insert(:issue)
      attrs = params_for(:sponsorship, issue: issue)
      conn = post(conn, Routes.sponsorship_path(conn, :create), sponsorship: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.sponsorship_path(conn, :show, id)

      conn = get(conn, Routes.sponsorship_path(conn, :show, id))
      response = html_response(conn, 200)
      assert response =~ issue.newsletter.name
      assert response =~ issue.name
      assert response =~ attrs.copy
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.sponsorship_path(conn, :create), sponsorship: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Sponsorship"
    end
  end

  describe "edit sponsorship" do
    setup [:create_sponsorship]

    test "renders form for editing chosen sponsorship", %{conn: conn, sponsorship: sponsorship} do
      conn = get(conn, Routes.sponsorship_path(conn, :edit, sponsorship))
      assert html_response(conn, 200) =~ "Edit Sponsorship"
    end
  end

  describe "update sponsorship" do
    setup [:create_sponsorship]

    test "redirects when data is valid", %{conn: conn, sponsorship: sponsorship} do
      attrs = params_for(:sponsorship)
      conn = put(conn, Routes.sponsorship_path(conn, :update, sponsorship), sponsorship: attrs)
      assert redirected_to(conn) == Routes.sponsorship_path(conn, :show, sponsorship)

      conn = get(conn, Routes.sponsorship_path(conn, :show, sponsorship))
      response = html_response(conn, 200)
      assert response =~ sponsorship.issue.newsletter.name
      assert response =~ sponsorship.issue.name
      assert response =~ attrs.copy
    end

    test "renders errors when data is invalid", %{conn: conn, sponsorship: sponsorship} do
      conn = put(conn, Routes.sponsorship_path(conn, :update, sponsorship), sponsorship: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Sponsorship"
    end
  end

  describe "delete sponsorship" do
    setup [:create_sponsorship]

    test "deletes chosen sponsorship", %{conn: conn, sponsorship: sponsorship} do
      conn = delete(conn, Routes.sponsorship_path(conn, :delete, sponsorship))
      assert redirected_to(conn) == Routes.sponsorship_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.sponsorship_path(conn, :show, sponsorship))
      end
    end
  end

  defp create_sponsorship(%{user: user}) do
    sponsorship = insert(:sponsorship, user: user)
    %{sponsorship: sponsorship}
  end
end
