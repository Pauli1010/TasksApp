# frozen_string_literal: true

module Admin
  class UserCreateForm < Rectify::Form
    # include ActionView::Helpers::TranslationHelper
    mimic :user

    attribute :admin
    attribute :email
    attribute :user_name
    attribute :first_name
    attribute :last_name

    validates :email, format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
      message: I18n.t('errors.email.invalid')
    }
    validate :email_uniqueness

    def email_uniqueness
      return if email.blank?

      errors.add(:email, I18n.t('errors.email.taken')) if User.find_by(email: downcase_email)
    end

    def downcase_email
      email.downcase
    end
  end
end