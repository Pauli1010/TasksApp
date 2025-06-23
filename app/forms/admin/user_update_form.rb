# frozen_string_literal: true

module Admin
  class UserUpdateForm < Rectify::Form
    # include ActionView::Helpers::TranslationHelper
    mimic :user

    attribute :admin
    attribute :user_name
    attribute :first_name
    attribute :last_name
  end
end