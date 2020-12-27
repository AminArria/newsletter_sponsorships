defmodule Sponsorly.NewslettersTest do
  use Sponsorly.DataCase, async: true

  alias Sponsorly.Newsletters

  describe "newsletters" do
    alias Sponsorly.Newsletters.Newsletter

    @invalid_attrs %{interval_days: nil, name: nil, sponsor_before_days: nil, sponsor_in_days: nil}

    test "list_newsletters/1 returns all newsletters of user" do
      newsletter = insert(:newsletter) |> unload_assocs([:user])
      other_newsletter = insert(:newsletter)

      assert newsletter.user_id != other_newsletter.user_id
      assert Newsletters.list_newsletters(newsletter.user_id) == [newsletter]
    end

    test "get_newsletter!/2 returns the newsletter with given id of user" do
      newsletter = insert(:newsletter) |> unload_assocs([:user])
      other_user = insert(:confirmed_user)

      assert newsletter.user_id != other_user.id
      assert Newsletters.get_newsletter!(newsletter.user_id, newsletter.id) == newsletter
      assert_raise Ecto.NoResultsError, fn ->
        Newsletters.get_newsletter!(newsletter.user_id, other_user.id)
      end
    end

    test "create_newsletter/1 with valid data creates a newsletter" do
      attrs = params_with_assocs(:newsletter)
      assert {:ok, %Newsletter{} = newsletter} = Newsletters.create_newsletter(attrs)
      assert newsletter.interval_days == newsletter.interval_days
      assert newsletter.name == newsletter.name
      assert newsletter.sponsor_before_days == newsletter.sponsor_before_days
      assert newsletter.sponsor_in_days == newsletter.sponsor_in_days
      assert newsletter.user_id == newsletter.user_id
    end

    test "create_newsletter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Newsletters.create_newsletter(@invalid_attrs)
    end

    test "update_newsletter/2 with valid data updates the newsletter" do
      original_newsletter = insert(:newsletter)
      attrs = params_with_assocs(:newsletter)
      assert {:ok, %Newsletter{} = newsletter} = Newsletters.update_newsletter(original_newsletter, attrs)
      assert newsletter.interval_days == attrs.interval_days
      assert newsletter.name == attrs.name
      assert newsletter.sponsor_before_days == attrs.sponsor_before_days
      assert newsletter.sponsor_in_days == attrs.sponsor_in_days
      # Can't change user_id
      assert original_newsletter.user_id != attrs.user_id
      assert newsletter.user_id == original_newsletter.user_id
    end

    test "update_newsletter/2 with invalid data returns error changeset" do
      newsletter = insert(:newsletter) |> unload_assocs([:user])
      assert {:error, %Ecto.Changeset{}} = Newsletters.update_newsletter(newsletter, @invalid_attrs)
      assert newsletter == Newsletters.get_newsletter!(newsletter.user_id, newsletter.id)
    end

    test "soft_delete_newsletter/1 soft deletes the newsletter" do
      newsletter = insert(:newsletter)
      assert {:ok, %Newsletter{deleted: true}} = Newsletters.soft_delete_newsletter(newsletter)
      refute Newsletters.list_newsletters(newsletter.user_id) == [newsletter]
      assert_raise Ecto.NoResultsError, fn -> Newsletters.get_newsletter!(newsletter.user_id, newsletter.id) end
    end

    test "change_newsletter/1 returns a newsletter changeset" do
      newsletter = build(:newsletter)
      assert %Ecto.Changeset{} = Newsletters.change_newsletter(newsletter)
    end
  end
end
