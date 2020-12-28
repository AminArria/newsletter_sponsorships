defmodule Sponsorly.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Sponsorly.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Sponsorly.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Sponsorly.DataCase
      import Sponsorly.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Sponsorly.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Sponsorly.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  @doc """
  Helper to unload assocs that are not preloaded when fetching them, but ex_machine
  has theme on `insert/1` so it feels they are "preloaded"
  """

  def unload_assocs(data, assocs) do
    Enum.reduce(assocs, data, fn field, acc ->
      cardinality =
        case Map.get(data, field) do
          value when is_list(value) -> :many
          _value -> :one
        end

      unloaded_field = %Ecto.Association.NotLoaded{
        __field__: field,
        __owner__: data.__struct__,
        __cardinality__: cardinality
      }

      Map.put(acc, field, unloaded_field)
    end)
  end

  @doc """
  Helper to check timestamps and give a margin of error (1 second by default) due to latency.

  Instead of doing

  ```
    assert time1 == time2
  ```

  Replace with

  ```
    assert check_timestamp(time1, time2)
  ```
  """

  def check_datetime(expected, actual, margin \\ 1) do
    DateTime.add(expected, margin, :second)
    |> DateTime.compare(actual)
    |> case do
      :gt -> true
      _ -> expected == actual
    end
  end
end
