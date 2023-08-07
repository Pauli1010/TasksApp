# frozen_string_literal: true

class AccountForm < Rectify::Form
  include ActionView::Helpers::TranslationHelper
  mimic :user

  attribute :user_name

  validates :user_name, length: { minimum: 3, maximum: 30 }, allow_blank: true
end