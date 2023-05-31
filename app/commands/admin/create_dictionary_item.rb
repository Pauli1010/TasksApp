# frozen_string_literal: true

class Admin::CreateDictionaryItem < Admin::CreateItem

  private

  def item_attributes
    {
      name: form.name,
      dictionary: form.dictionary
    }
  end

  def item_class
    ::DictionaryItem
  end
end