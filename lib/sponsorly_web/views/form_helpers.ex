defmodule SponsorlyWeb.FormHelpers do
  @moduledoc """
  Conveniences for building forms.
  """

  use Phoenix.HTML
  import SponsorlyWeb.ErrorHelpers

  def error_alert do
    ~E"""
    <div class="notification is-danger is-light" role="alert">
      <button class="delete"></button>
      Oops, something went wrong! Please check the errors below.
    </div>
    """
  end

  def error_alert(%Ecto.Changeset{action: nil}) do
    nil
  end

  def error_alert(%Ecto.Changeset{} = c) do
    IO.inspect(c)
    error_alert()
  end

  def text_control(form, field, name, required) do
    has_error = if Keyword.has_key?(form.errors, field), do: "is-danger"

    ~E"""
    <div class="field">
      <%= label form, field, name, class: "label" %>
      <div class="control">
        <%= apply(Phoenix.HTML.Form, input_type(form, field), [form, field, [class: "input #{has_error}", required: required]]) %>
      </div>
      <%= error_tag form, field %>
    </div>
    """
  end
end
