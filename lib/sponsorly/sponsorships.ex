defmodule Sponsorly.Sponsorships do
  @moduledoc """
  The Sponsorships context.
  """

  import Ecto.Query, warn: false
  alias Sponsorly.Repo

  alias Sponsorly.Sponsorships.Sponsorship

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
end
