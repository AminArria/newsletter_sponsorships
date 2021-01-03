defmodule Sponsorly.Newsletters do
  @moduledoc """
  The Newsletters context.
  """

  import Ecto.Query, warn: false
  alias Sponsorly.Repo

  alias Sponsorly.Newsletters.Newsletter

  @doc """
  Returns the list of newsletters of a user.

  ## Examples

      iex> list_newsletters(user_id)
      [%Newsletter{}, ...]

  """
  def list_newsletters(user_id) do
    q =
      from n in Newsletter,
      where: n.user_id == ^user_id and
             not n.deleted

    Repo.all(q)
  end

  @doc """
  Gets a single newsletter of a user.

  Raises `Ecto.NoResultsError` if the Newsletter does not exist for that user.

  ## Examples

      iex> get_newsletter!(user_id, 123)
      %Newsletter{}

      iex> get_newsletter!(user_id, 456)
      ** (Ecto.NoResultsError)

  """
  def get_newsletter!(user_id, id) do
    q =
      from n in Newsletter,
      where: n.id == ^id and
             n.user_id == ^user_id and
             not n.deleted

    Repo.one!(q)
  end

  @doc """
  Creates a newsletter.

  ## Examples

      iex> create_newsletter(%{field: value})
      {:ok, %Newsletter{}}

      iex> create_newsletter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_newsletter(attrs \\ %{}) do
    %Newsletter{}
    |> Newsletter.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a newsletter.

  ## Examples

      iex> update_newsletter(newsletter, %{field: new_value})
      {:ok, %Newsletter{}}

      iex> update_newsletter(newsletter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_newsletter(%Newsletter{} = newsletter, attrs) do
    newsletter
    |> Newsletter.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Soft deletes a newsletter.

  ## Examples

      iex> soft_delete_newsletter(newsletter)
      {:ok, %Newsletter{}}

      iex> soft_delete_newsletter(newsletter)
      {:error, %Ecto.Changeset{}}

  """
  def soft_delete_newsletter(%Newsletter{} = newsletter) do
    newsletter
    |> Newsletter.soft_delete_changeset()
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking newsletter changes.

  ## Examples

      iex> change_newsletter(newsletter)
      %Ecto.Changeset{data: %Newsletter{}}

  """
  def change_newsletter(newsletter, attrs \\ %{})

  def change_newsletter(%Newsletter{id: nil} = newsletter, attrs) do
    Newsletter.create_changeset(newsletter, attrs)
  end

  def change_newsletter(%Newsletter{} = newsletter, attrs) do
    Newsletter.update_changeset(newsletter, attrs)
  end

  alias Sponsorly.Newsletters.Issue

  @doc """
  Returns the list of issues

  ## Examples

      iex> list_issues()
      [%Issue{}, ...]

  """
  def list_issues() do
    q =
      from i in Issue,
      where: not i.deleted

    Repo.all(q)
    |> Repo.preload(:newsletter)
  end

  @doc """
  Returns the list of issues of a newsletter.

  ## Examples

      iex> list_issues(newsletter_id)
      [%Issue{}, ...]

  """
  def list_issues(newsletter_id) do
    q =
      from i in Issue,
      where: i.newsletter_id == ^newsletter_id and
             not i.deleted

    Repo.all(q)
  end

  @doc """
  Gets a single issue of a newsletter.

  Raises `Ecto.NoResultsError` if the Issue does not exist.

  ## Examples

      iex> get_issue!(123)
      %Issue{}

      iex> get_issue!(456)
      ** (Ecto.NoResultsError)

  """
  def get_issue!(newsletter_id, id) do
    q =
      from i in Issue,
      where: i.id == ^id and
             i.newsletter_id == ^newsletter_id and
             not i.deleted

    Repo.one!(q)
  end

  @doc """
  Creates an issue.

  ## Examples

      iex> create_issue(%{field: value})
      {:ok, %Issue{}}

      iex> create_issue(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_issue(attrs \\ %{}) do
    %Issue{}
    |> Issue.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an issue.

  ## Examples

      iex> update_issue(issue, %{field: new_value})
      {:ok, %Issue{}}

      iex> update_issue(issue, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_issue(%Issue{} = issue, attrs) do
    issue
    |> Issue.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Soft deletes a issue.

  ## Examples

      iex> soft_delete_issue(issue)
      {:ok, %Issue{}}

      iex> soft_delete_issue(issue)
      {:error, %Ecto.Changeset{}}

  """
  def soft_delete_issue(%Issue{} = issue) do
    issue
    |> Issue.soft_delete_changeset()
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking issue changes.

  ## Examples

      iex> change_issue(issue)
      %Ecto.Changeset{data: %Issue{}}

  """
  def change_issue(issue, attrs \\ %{})

  def change_issue(%Issue{id: nil} = issue, attrs) do
    Issue.create_changeset(issue, attrs)
  end

  def change_issue(%Issue{} = issue, attrs) do
    Issue.update_changeset(issue, attrs)
  end
end
