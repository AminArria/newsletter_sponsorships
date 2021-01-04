defmodule SponsorlyWeb.NewsletterControllerTest do
  use SponsorlyWeb.ConnCase, async: true

  @invalid_attrs %{interval_days: nil, name: nil, sponsor_before_days: nil, sponsor_in_days: nil}

  setup :register_and_log_in_user

  describe "index" do
    setup :create_newsletter

    test "lists all newsletters of user", %{conn: conn, newsletter: newsletter} do
      other_newsletter = insert(:newsletter)

      conn = get(conn, Routes.newsletter_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ newsletter.name
      refute response =~ other_newsletter.name
    end
  end

  describe "new newsletter" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.newsletter_path(conn, :new))
      assert html_response(conn, 200) =~ "New Newsletter"
    end
  end

  describe "create newsletter" do
    test "redirects to show when data is valid", %{conn: conn} do
      next_issue_at = DateTime.utc_now() |> DateTime.add(24 * 60 * 60)
      attrs = params_for(:newsletter, next_issue_at: next_issue_at)
      conn = post(conn, Routes.newsletter_path(conn, :create), newsletter: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.newsletter_path(conn, :show, id)

      conn = get(conn, Routes.newsletter_path(conn, :show, id))
      response = html_response(conn, 200)
      assert response =~ attrs.name
      assert response =~ attrs.slug
      assert response =~ "#{attrs.interval_days}"
      assert response =~ "#{attrs.sponsor_before_days}"
      assert response =~ "#{attrs.sponsor_in_days}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.newsletter_path(conn, :create), newsletter: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Newsletter"
    end
  end

  describe "edit newsletter" do
    setup [:create_newsletter]

    test "renders form for editing chosen newsletter", %{conn: conn, newsletter: newsletter} do
      conn = get(conn, Routes.newsletter_path(conn, :edit, newsletter))
      assert html_response(conn, 200) =~ "Edit Newsletter"
    end
  end

  describe "update newsletter" do
    setup [:create_newsletter]

    test "redirects when data is valid", %{conn: conn, newsletter: newsletter} do
      attrs = params_for(:newsletter)
      conn = put(conn, Routes.newsletter_path(conn, :update, newsletter), newsletter: attrs)
      assert redirected_to(conn) == Routes.newsletter_path(conn, :show, newsletter)

      conn = get(conn, Routes.newsletter_path(conn, :show, newsletter))
      response = html_response(conn, 200)
      assert response =~ attrs.name
      assert response =~ attrs.slug
      assert response =~ "#{attrs.interval_days}"
      assert response =~ "#{attrs.sponsor_before_days}"
      assert response =~ "#{attrs.sponsor_in_days}"
    end

    test "renders errors when data is invalid", %{conn: conn, newsletter: newsletter} do
      conn = put(conn, Routes.newsletter_path(conn, :update, newsletter), newsletter: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Newsletter"
    end
  end

  describe "delete newsletter" do
    setup [:create_newsletter]

    test "soft deletes chosen newsletter", %{conn: conn, newsletter: newsletter} do
      conn = delete(conn, Routes.newsletter_path(conn, :delete, newsletter))
      assert redirected_to(conn) == Routes.newsletter_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.newsletter_path(conn, :show, newsletter))
      end
    end
  end

  defp create_newsletter(%{user: user}) do
    newsletter = insert(:newsletter, user: user)
    %{newsletter: newsletter}
  end
end
