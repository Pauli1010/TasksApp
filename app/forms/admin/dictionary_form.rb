# frozen_string_literal: true

module Admin
  class DictionaryForm < Rectify::Form
    mimic :dictionary

    attribute :name

    validates :name, presence: true
  end
end