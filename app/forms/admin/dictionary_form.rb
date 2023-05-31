# frozen_string_literal: true

class Admin::DictionaryForm < Rectify::Form
  mimic :dictionary

  attribute :name

  validates :name, presence: true
end