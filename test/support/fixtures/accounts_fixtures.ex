defmodule Sponsorly.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sponsorly.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password()
      })
      |> Sponsorly.Accounts.register_user()

    Sponsorly.Accounts.User.confirm_changeset(user)
    |> Sponsorly.Repo.update!
  end

  def unconfirmed_user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password()
      })
      |> Sponsorly.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    # {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    %Bamboo.Email{text_body: text_body} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(text_body, "[TOKEN]")
    token
  end
end
