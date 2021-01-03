defmodule Sponsorly.SponsorshipsTest do
  use Sponsorly.DataCase, async: true

  alias Sponsorly.Sponsorships

  describe "sponsorships" do
    alias Sponsorly.Sponsorships.Sponsorship

    @invalid_attrs %{copy: nil}

    test "list_sponsorships/1 returns all sponsorships of a user" do
      sponsorship = insert(:sponsorship) |> unload_assocs([:user, issue: [newsletter: [:user]]])
      insert(:sponsorship)

      assert Sponsorships.list_sponsorships(sponsorship.user_id) == [sponsorship]
    end

    test "list_sponsorships_for_issue/1 returns all sponsorships of an issue" do
      sponsorship = insert(:sponsorship) |> unload_assocs([:issue])
      insert(:sponsorship)

      assert Sponsorships.list_sponsorships_for_issue(sponsorship.issue_id) == [sponsorship]
    end

    test "get_sponsorship!/2 returns the sponsorship of a user with given id" do
      sponsorship = insert(:sponsorship) |> unload_assocs([:user, issue: [newsletter: [:user]]])
      other_sponsorship = insert(:sponsorship)

      assert Sponsorships.get_sponsorship!(sponsorship.user_id, sponsorship.id) == sponsorship
      assert_raise Ecto.NoResultsError, fn ->
        Sponsorships.get_sponsorship!(sponsorship.user_id, other_sponsorship.id)
      end
    end

    test "create_sponsorship/1 with valid data creates a sponsorship" do
      attrs = params_with_assocs(:sponsorship)
      assert {:ok, %Sponsorship{} = sponsorship} = Sponsorships.create_sponsorship(attrs)
      assert sponsorship.copy == sponsorship.copy
      assert sponsorship.issue_id == sponsorship.issue_id
      assert sponsorship.user_id == sponsorship.user_id
    end

    test "create_sponsorship/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sponsorships.create_sponsorship(@invalid_attrs)
    end

    test "update_sponsorship/2 with valid data updates the sponsorship" do
      original_sponsorship = insert(:sponsorship)
      attrs = params_with_assocs(:sponsorship)
      assert {:ok, %Sponsorship{} = sponsorship} = Sponsorships.update_sponsorship(original_sponsorship, attrs)
      assert sponsorship.copy == attrs.copy
      assert sponsorship.issue_id == original_sponsorship.issue_id
      assert sponsorship.user_id == original_sponsorship.user_id
    end

    test "update_sponsorship/2 with invalid data returns error changeset" do
      sponsorship = insert(:sponsorship) |> unload_assocs([:user, issue: [newsletter: [:user]]])
      assert {:error, %Ecto.Changeset{}} = Sponsorships.update_sponsorship(sponsorship, @invalid_attrs)
      assert sponsorship == Sponsorships.get_sponsorship!(sponsorship.user_id, sponsorship.id)
    end

    test "soft_delete_sponsorship/1 soft deletes the sponsorship" do
      sponsorship = insert(:sponsorship)
      assert {:ok, %Sponsorship{deleted: true}} = Sponsorships.soft_delete_sponsorship(sponsorship)
      assert_raise Ecto.NoResultsError, fn -> Sponsorships.get_sponsorship!(sponsorship.user_id, sponsorship.id) end
      refute Sponsorships.list_sponsorships(sponsorship.user_id) == [sponsorship]
    end

    test "change_sponsorship/1 returns a sponsorship changeset" do
      sponsorship = insert(:sponsorship)
      assert %Ecto.Changeset{} = Sponsorships.change_sponsorship(sponsorship)
    end
  end
end
