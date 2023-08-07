# frozen_string_literal: true

class UpdateAccount < Rectify::Command
  def initialize(form, current_user)
    @form = form
    @user = current_user
  end

  def call
    return broadcast(:invalid) if form.invalid?

    transaction do
      update_user
    end

    broadcast(:ok)
  end

  private

  attr_reader :form, :user

  def update_user
    user.update(account_attributes)
  end

  def account_attributes
    {
      user_name: form.user_name
    }
  end
end