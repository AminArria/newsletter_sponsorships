defmodule Sponsorly.Factory do
  use ExMachina.Ecto, repo: Sponsorly.Repo

  def confirmed_user_factory do
    %Sponsorly.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      hashed_password: Bcrypt.hash_pwd_salt("123456781234"),
      confirmed_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    }
  end

  def newsletter_factory do
    %Sponsorly.Newsletters.Newsletter{
      interval_days: :rand.uniform(7),
      name: sequence("name"),
      sponsor_before_days: :rand.uniform(7),
      sponsor_in_days: :rand.uniform(365),
      user: build(:confirmed_user)
    }
  end

  def issue_factory do
    %Sponsorly.Newsletters.Issue{
      name: sequence("name"),
      due_at: DateTime.add(DateTime.utc_now(), :rand.uniform(100) * 24 * 60 * 60),
      newsletter: build(:newsletter)
    }
  end
end
