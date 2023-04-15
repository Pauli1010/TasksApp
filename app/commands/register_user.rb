# frozen_string_literal: true

class RegisterUser < Rectify::Command
  def initialize(form)
    @form = form
  end

  def call
    return broadcast(:invalid) if form.invalid?

    transaction do
      create_user
    end

    broadcast(:ok, user)
  end

  private

  attr_reader :form, :user

  def create_user
    @user = User.create(registration_attributes)
  end

  def registration_attributes
    {
      email: form.downcase_email,
      password: form.password,
      password_confirmation: form.password_confirmation
    }
  end
end