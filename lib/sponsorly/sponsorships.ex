defmodule Sponsorly.Sponsorships do
  @moduledoc """
  The Sponsorships context.
  """

  import Ecto.Query, warn: false
  alias Sponsorly.Repo
  alias Sponsorly.Sponsorships.Sponsorship
  alias Sponsorly.Sponsorships.ConfirmedSponsorship
  alias Sponsorly.Sponsorships.SponsorshipNotifier

  @doc """
  Link existing sponsorships from an email to user (owner of that email).

  ## Examples

      iex> link_sponsorships_to_user(user)
      [%Sponsorship{}, ...]

  """
  def link_sponsorships_to_user(user) do
    email = user.email

    q =
      from s in Sponsorship,
      where: s.email == ^email and
             is_nil(s.user_id)

    Repo.update_all(q, set: [user_id: user.id])
  end

  @doc """
  Returns the list of sponsorships of a user.

  ## Examples

      iex> list_sponsorships(user_id)
      [%Sponsorship{}, ...]

  """
  def list_sponsorships(user_id) do
    q =
      from s in Sponsorship,
      where: s.user_id == ^user_id and
             not s.deleted

    Repo.all(q)
    |> Repo.preload(issue: :newsletter)
  end

  def list_confirmed_sponsorships(user_id) do
    now = NaiveDateTime.utc_now()

    q =
      from s in Sponsorship,
      left_join: i in assoc(s, :issue),
      inner_join: cs in assoc(s, :confirmed_sponsorship),
      where: s.user_id == ^user_id and
             i.due_at > ^now,
      order_by: [asc: i.due_at],
      preload: [confirmed_sponsorship: cs, issue: {i, :newsletter}]

    Repo.all(q)
  end

  def list_pending_sponsorships(user_id) do
    now = NaiveDateTime.utc_now()

    q =
      from s in Sponsorship,
      left_join: i in assoc(s, :issue),
      left_join: cs in assoc(s, :confirmed_sponsorship),
      where: s.user_id == ^user_id and
             is_nil(cs.issue_id) and
             i.due_at > ^now,
      order_by: [asc: i.due_at],
      preload: [issue: {i, :newsletter}]

    Repo.all(q)
  end

  def list_past_sponsorships(user_id) do
    now = NaiveDateTime.utc_now()

    q =
      from s in Sponsorship,
      left_join: i in assoc(s, :issue),
      where: s.user_id == ^user_id and
             i.due_at <= ^now,
      order_by: [desc: i.due_at],
      preload: [:confirmed_sponsorship, issue: {i, :newsletter}]

    Repo.all(q)
  end

  @doc """
  Returns the list of sponsorships for an issue.

  ## Examples

      iex> list_sponsorships_for_issue(issue_id)
      [%Sponsorship{}, ...]

  """
  def list_sponsorships_for_issue(issue_id) do
    q =
      from s in Sponsorship,
      where: s.issue_id == ^issue_id and
             not s.deleted

    Repo.all(q)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single sponsorship of a user.

  Raises `Ecto.NoResultsError` if the Sponsorship does not exist.

  ## Examples

      iex> get_sponsorship!(user_id, 123)
      %Sponsorship{}

      iex> get_sponsorship!(user_id, 456)
      ** (Ecto.NoResultsError)

  """
  def get_sponsorship!(user_id, id) do
    q =
      from s in Sponsorship,
      where: s.id == ^id and
             s.user_id == ^user_id and
             not s.deleted

    Repo.one!(q)
    |> Repo.preload(issue: :newsletter)
  end

  @doc """
  Gets a single sponsorship by email and id.

  Raises `Ecto.NoResultsError` if the Sponsorship does not exist.

  ## Examples

      iex> get_sponsorship!(id, email)
      %Sponsorship{}

      iex> get_sponsorship!(id, email)
      ** (Ecto.NoResultsError)

  """
  def get_sponsorship_by_email_and_id!(id, email) do
    q =
      from s in Sponsorship,
      where: s.id == ^id and
             s.email == ^email and
             not s.deleted

    Repo.one!(q)
    |> Repo.preload(issue: :newsletter)
  end

  @doc """
  Gets a single sponsorship of an issue.

  Raises `Ecto.NoResultsError` if the Sponsorship does not exist.

  ## Examples

      iex> get_sponsorship_for_issue!(issue_id, 123)
      %Sponsorship{}

      iex> get_sponsorship_for_issue!(issue_id, 456)
      ** (Ecto.NoResultsError)

  """
  def get_sponsorship_for_issue!(issue_id, id) do
    q =
      from s in Sponsorship,
      where: s.id == ^id and
             s.issue_id == ^issue_id and
             not s.deleted

    Repo.one!(q)
    |> Repo.preload(:issue)
  end

  @doc """
  Creates a sponsorship.

  ## Examples

      iex> create_sponsorship(%{field: value})
      {:ok, %Sponsorship{}}

      iex> create_sponsorship(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sponsorship(attrs \\ %{}) do
    %Sponsorship{}
    |> Sponsorship.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sponsorship.

  ## Examples

      iex> update_sponsorship(sponsorship, %{field: new_value})
      {:ok, %Sponsorship{}}

      iex> update_sponsorship(sponsorship, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sponsorship(%Sponsorship{} = sponsorship, attrs) do
    sponsorship
    |> Sponsorship.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Soft deletes a sponsorship.

  ## Examples

      iex> soft_delete_sponsorship(sponsorship)
      {:ok, %Sponsorship{}}

      iex> soft_delete_sponsorship(sponsorship)
      {:error, %Ecto.Changeset{}}

  """
  def soft_delete_sponsorship(%Sponsorship{} = sponsorship) do
    sponsorship
    |> Sponsorship.soft_delete_changeset()
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sponsorship changes.

  ## Examples

      iex> change_sponsorship(sponsorship)
      %Ecto.Changeset{data: %Sponsorship{}}

  """
  def change_sponsorship(sponsorship, attrs \\ %{})

  def change_sponsorship(%Sponsorship{id: nil} = sponsorship, attrs) do
    Sponsorship.create_changeset(sponsorship, attrs)
  end

  def change_sponsorship(%Sponsorship{} = sponsorship, attrs) do
    Sponsorship.update_changeset(sponsorship, attrs)
  end

  @doc """
  Gets a single confirmed_sponsorship.

  Raises `Ecto.NoResultsError` if the Confirmed sponsorship does not exist.

  ## Examples

      iex> get_confirmed_sponsorship!(123)
      %ConfirmedSponsorship{}

      iex> get_confirmed_sponsorship!(456)
      ** (Ecto.NoResultsError)

  """
  def get_confirmed_sponsorship!(id) do
    Repo.get!(ConfirmedSponsorship, id)
    |> Repo.preload([:issue, :sponsorship])
  end

  @doc """
  Creates a confirmed_sponsorship.

  ## Examples

      iex> create_confirmed_sponsorship(%{field: value})
      {:ok, %ConfirmedSponsorship{}}

      iex> create_confirmed_sponsorship(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_confirmed_sponsorship(attrs \\ %{}) do
    %ConfirmedSponsorship{}
    |> ConfirmedSponsorship.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a confirmed_sponsorship.

  ## Examples

      iex> update_confirmed_sponsorship(confirmed_sponsorship, %{field: new_value})
      {:ok, %ConfirmedSponsorship{}}

      iex> update_confirmed_sponsorship(confirmed_sponsorship, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_confirmed_sponsorship(%ConfirmedSponsorship{} = confirmed_sponsorship, attrs) do
    confirmed_sponsorship
    |> ConfirmedSponsorship.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a confirmed_sponsorship.

  ## Examples

      iex> delete_confirmed_sponsorship(confirmed_sponsorship)
      {:ok, %ConfirmedSponsorship{}}

      iex> delete_confirmed_sponsorship(confirmed_sponsorship)
      {:error, %Ecto.Changeset{}}

  """
  def delete_confirmed_sponsorship(%ConfirmedSponsorship{} = confirmed_sponsorship) do
    Repo.delete(confirmed_sponsorship)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking confirmed_sponsorship changes.

  ## Examples

      iex> change_confirmed_sponsorship(confirmed_sponsorship)
      %Ecto.Changeset{data: %ConfirmedSponsorship{}}

  """
  def change_confirmed_sponsorship(%ConfirmedSponsorship{} = confirmed_sponsorship, attrs \\ %{}) do
    ConfirmedSponsorship.update_changeset(confirmed_sponsorship, attrs)
  end

  @doc """
  Delivers the notification about a confirmed sponsorship
  """
  def deliver_confirmed_sponsorship(sponsorship) do
    sponsorship = Repo.preload(sponsorship, [:user, issue: :newsletter])
    email = sponsorship_email(sponsorship)
    SponsorshipNotifier.deliver_sponsorship_confirmation(email, sponsorship)
  end

  defp sponsorship_email(%{user: nil, email: email}) do
    email
  end

  defp sponsorship_email(%{user: user}) do
    user.email
  end
end
