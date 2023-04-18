# frozen_string_literal: true

class RegistrationForm < Rectify::Form
  include ActionView::Helpers::TranslationHelper
  mimic :user

  attribute :email
  attribute :password
  attribute :password_confirmation

  validates :password, presence: { message: I18n.t('errors.password.required') }
  validates :password, length: { minimum: 3, message: I18n.t('errors.password.too_short') }
  validates :password, confirmation: { message: I18n.t('errors.password_confirmation.different') }
  validates :password_confirmation, presence: { message: I18n.t('errors.password_confirmation.required') }

  validates :email, presence: { message: I18n.t('errors.email.required') }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: I18n.t('errors.email.invalid') }
  validate :email_uniqueness

  def email_uniqueness
    return if email.blank?

    errors.add(:email, I18n.t('errors.email.taken')) if User.find_by(email: downcase_email)
  end

  def downcase_email
    email.downcase
  end
end