# frozen_string_literal: true

class Dictionary < ApplicationRecord
  has_many :dictionary_items, dependent: :destroy

  scope :alphabetically, -> { order(name: :asc) }

  def destroyable?
    true
  end
end
