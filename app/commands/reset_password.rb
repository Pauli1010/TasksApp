# frozen_string_literal: true

class ResetPassword < Rectify::Command
  def initialize(form)
    @form = form
    @user = form.user
  end

  def call
    return broadcast(:invalid) unless form.valid?

    user.deliver_reset_password_instructions!

    broadcast(:ok)
  end

  private

  attr_reader :form, :user
end