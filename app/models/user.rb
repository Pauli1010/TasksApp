# frozen_string_literal: true

# User is a model that holds logic to maintain Users
class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password_confirmation

  # validates :password, presence: { message: I18n.t('errors.password.required') }, if: -> { new_record? || changes[:crypted_password] }
  # validates :password, length: { minimum: 3, message: I18n.t('errors.password.too_short') }, if: -> { new_record? || changes[:crypted_password] }
  # validates :password, confirmation: { message: I18n.t('errors.password_confirmation.different') }, if: -> { new_record? || changes[:crypted_password] }
  # validates :password_confirmation, presence: { message: I18n.t('errors.password_confirmation.required') }, if: -> { new_record? || changes[:crypted_password] }
  #
  # validates :email, presence: { message: I18n.t('errors.email.required') }
  # validates :email, uniqueness: { case_sensitive: false, message: I18n.t('errors.email.taken') }
  # validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: I18n.t('errors.email.invalid') }

  def activation_state_pending?
    activation_state == 'pending'
  end

  # Public method returning data for Avatar
  def initials
    # "#{first_name.first}#{last_name.first}"
    user_name&.first.presence || email.first
  end
end
