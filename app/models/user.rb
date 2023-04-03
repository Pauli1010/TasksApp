# frozen_string_literal: true

# User is a model that holds logic to maintain Users
class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, presence: { message: I18n.t('errors.password.required') }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: { message: I18n.t('errors.password_confirmation.different') }, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: { message: I18n.t('errors.password_confirmation.required') }, if: -> { new_record? || changes[:crypted_password] }

  validates :email, presence: { message: I18n.t('errors.email.required') }
  validates :email, uniqueness: { case_sensitive: false, message: I18n.t('errors.email.taken') }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: I18n.t('errors.email.invalid') }

end
