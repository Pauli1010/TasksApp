# frozen_string_literal: true

class Admin::DictionaryItemForm < Rectify::Form
  mimic :dictionary_item

  attribute :name
  attribute :dictionary_id

  validates :name, presence: true
  validates :dictionary_id, presence: true
  validate :dictionary_exists

  def dictionary_exists
    return unless dictionary_id

    errors.add(:dictionary_id, 'dictionary_not_found') unless dictionary
  end

  def dictionary
    Dictionary.find_by(id: dictionary_id)
  end

  def dictionaries
    Dictionary.all
  end
end