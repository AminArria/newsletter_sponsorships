defmodule SponsorlyWeb.ConfirmedSponsorshipControllerTest do
  use SponsorlyWeb.ConnCase

  @invalid_attrs %{copy: nil}

  setup :register_and_log_in_user

  describe "create confirmed_sponsorship" do
    test "redirects to issue show when data is valid", %{conn: conn} do
      attrs = params_with_assocs(:confirmed_sponsorship)
      conn = post(conn, Routes.confirmed_sponsorship_path(conn, :create), confirmed_sponsorship: attrs)

      assert %{id: issue_id, newsletter_id: newsletter_id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.newsletter_issue_path(conn, :show, newsletter_id, issue_id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      assert_error_sent 400, fn ->
        post(conn, Routes.confirmed_sponsorship_path(conn, :create), confirmed_sponsorship: @invalid_attrs)
      end
    end
  end

  describe "edit confirmed_sponsorship" do
    setup [:create_confirmed_sponsorship]

    test "renders form for editing chosen confirmed_sponsorship", %{conn: conn, confirmed_sponsorship: confirmed_sponsorship} do
      conn = get(conn, Routes.confirmed_sponsorship_path(conn, :edit, confirmed_sponsorship))
      assert html_response(conn, 200) =~ "Edit Confirmed sponsorship"
    end
  end

  describe "update confirmed_sponsorship" do
    setup [:create_confirmed_sponsorship]

    test "redirects when data is valid", %{conn: conn, confirmed_sponsorship: confirmed_sponsorship} do
      attrs = params_with_assocs(:confirmed_sponsorship)
      conn = put(conn, Routes.confirmed_sponsorship_path(conn, :update, confirmed_sponsorship), confirmed_sponsorship: attrs)

      assert %{id: issue_id, newsletter_id: newsletter_id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.newsletter_issue_path(conn, :show, newsletter_id, issue_id)
    end

    test "renders errors when data is invalid", %{conn: conn, confirmed_sponsorship: confirmed_sponsorship} do
      assert_error_sent 500, fn ->
        put(conn, Routes.confirmed_sponsorship_path(conn, :update, confirmed_sponsorship), confirmed_sponsorship: @invalid_attrs)
      end
    end
  end

  describe "delete confirmed_sponsorship" do
    setup [:create_confirmed_sponsorship]

    test "deletes chosen confirmed_sponsorship", %{conn: conn, confirmed_sponsorship: confirmed_sponsorship} do
      conn = delete(conn, Routes.confirmed_sponsorship_path(conn, :delete, confirmed_sponsorship))
      assert %{id: issue_id, newsletter_id: newsletter_id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.newsletter_issue_path(conn, :show, newsletter_id, issue_id)
    end
  end

  defp create_confirmed_sponsorship(_) do
    confirmed_sponsorship = insert(:confirmed_sponsorship)
    %{confirmed_sponsorship: confirmed_sponsorship}
  end
end
