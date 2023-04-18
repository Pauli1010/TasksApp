# frozen_string_literal: true

class ResetPasswordForm < Rectify::Form
  attribute :email

  validates :email, presence: { message: I18n.t('errors.email.required') }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: I18n.t('errors.email.invalid') }
  validate :email_exists

  def email_exists
    return if email.blank?

    errors.add(:email, I18n.t('errors.email.required')) unless user
  end
  def user
    User.find_by(email: email)
  end
end