# frozen_string_literal: true

class ChangePassword < Rectify::Command
  def initialize(form, user)
    @form = form
    @user = user
    @new_password = @form.password
  end

  def call
    return broadcast(:invalid) unless form.valid?

    user.change_password!(new_password)

    broadcast(:ok)
  end

  private

  attr_reader :form, :user, :new_password
end