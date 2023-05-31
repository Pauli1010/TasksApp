# frozen_string_literal: true

class DictionaryItem < ApplicationRecord
  belongs_to :dictionary

  scope :alphabetically, -> { order(name: :asc) }

  def destroyable?
    true
  end
end
