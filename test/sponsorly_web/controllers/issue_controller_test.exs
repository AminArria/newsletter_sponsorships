defmodule SponsorlyWeb.IssueControllerTest do
  use SponsorlyWeb.ConnCase, async: true

  @invalid_attrs %{due_at: nil}

  setup [
    :register_and_log_in_user,
    :create_newsletter
  ]

  describe "index" do
    setup :create_issue

    test "lists all issues of a newsletter", %{conn: conn, issue: issue} do
      other_issue = insert(:newsletter)

      conn = get(conn, Routes.newsletter_issue_path(conn, :index, issue.newsletter_id))
      response = html_response(conn, 200)
      assert response =~ issue.newsletter.name
      assert response =~ issue.name
      refute response =~ other_issue.name
    end
  end

  describe "show" do
    setup :create_issue

    test "lists all sponsorships of an issue", %{conn: conn, issue: issue} do
      [sponsorship1, sponsorship2] = insert_pair(:sponsorship, issue: issue)

      conn = get(conn, Routes.newsletter_issue_path(conn, :show, issue.newsletter_id, issue))
      response = html_response(conn, 200)
      assert response =~ sponsorship1.user.email
      assert response =~ sponsorship1.copy

      assert response =~ sponsorship2.user.email
      assert response =~ sponsorship2.copy
    end
  end

  describe "new issue" do
    test "renders form", %{conn: conn, newsletter: newsletter} do
      conn = get(conn, Routes.newsletter_issue_path(conn, :new, newsletter))
      assert html_response(conn, 200) =~ "New Issue"
    end
  end

  describe "create issue" do
    test "redirects to show when data is valid", %{conn: conn, newsletter: newsletter} do
      attrs = params_for(:issue, newsletter: newsletter)
      conn = post(conn, Routes.newsletter_issue_path(conn, :create, newsletter), issue: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.newsletter_issue_path(conn, :show, newsletter, id)

      conn = get(conn, Routes.newsletter_issue_path(conn, :show, newsletter, id))
      response = html_response(conn, 200)
      assert response =~ attrs.name
    end

    test "renders errors when data is invalid", %{conn: conn, newsletter: newsletter} do
      conn = post(conn, Routes.newsletter_issue_path(conn, :create, newsletter), issue: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Issue"
    end
  end

  describe "edit issue" do
    setup [:create_issue]

    test "renders form for editing chosen issue", %{conn: conn, issue: issue} do
      conn = get(conn, Routes.newsletter_issue_path(conn, :edit, issue.newsletter_id, issue))
      assert html_response(conn, 200) =~ "Edit Issue"
    end
  end

  describe "update issue" do
    setup [:create_issue]

    test "redirects when data is valid", %{conn: conn, issue: issue} do
      attrs = params_for(:issue, newsletter: issue.newsletter)
      conn = put(conn, Routes.newsletter_issue_path(conn, :update, issue.newsletter, issue), issue: attrs)
      assert redirected_to(conn) == Routes.newsletter_issue_path(conn, :show, issue.newsletter, issue)

      conn = get(conn, Routes.newsletter_issue_path(conn, :show, issue.newsletter, issue))
      response = html_response(conn, 200)
      assert response =~ attrs.name
    end

    test "renders errors when data is invalid", %{conn: conn, issue: issue} do
      conn = put(conn, Routes.newsletter_issue_path(conn, :update, issue.newsletter, issue), issue: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Issue"
    end
  end

  describe "delete issue" do
    setup [:create_issue]

    test "soft deletes chosen issue", %{conn: conn, issue: issue} do
      conn = delete(conn, Routes.newsletter_issue_path(conn, :delete, issue.newsletter, issue))
      assert redirected_to(conn) == Routes.newsletter_issue_path(conn, :index, issue.newsletter)
      assert_error_sent 404, fn ->
        get(conn, Routes.newsletter_issue_path(conn, :show, issue, issue.newsletter))
      end
    end
  end

  defp create_newsletter(%{user: user}) do
    newsletter = insert(:newsletter, user: user)
    %{newsletter: newsletter}
  end

  defp create_issue(%{newsletter: newsletter}) do
    issue = insert(:issue, newsletter: newsletter)
    %{issue: issue}
  end
end
