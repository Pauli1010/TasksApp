# frozen_string_literal: true

class ChangePasswordForm < Rectify::Form
  mimic :user

  attribute :password
  attribute :password_confirmation

  validates :password, presence: { message: I18n.t('errors.password.required') }
  validates :password, length: { minimum: 3, message: I18n.t('errors.password.too_short') }
  validates :password, confirmation: { message: I18n.t('errors.password_confirmation.different') }
  validates :password_confirmation, presence: { message: I18n.t('errors.password_confirmation.required') }
end