defmodule SponsorlyWeb.LayoutView do
  use SponsorlyWeb, :view

  def flash(nil, _) do
    nil
  end

  def flash(content, :info) do
    ~E"""
    <div class="notification is-info is-light" role="alert">
      <button class="delete"></button>
      <%= content %>
    </div>
    """
  end

  def flash(content, :error) do
    ~E"""
    <div class="notification is-danger is-light" role="alert">
      <button class="delete"></button>
      <%= content %>
    </div>
    """
  end
end
