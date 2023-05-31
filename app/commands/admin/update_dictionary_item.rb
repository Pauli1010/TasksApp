# frozen_string_literal: true

class Admin::UpdateDictionaryItem < Admin::UpdateItem

  private

  def item_attributes
    {
      name: form.name,
      dictionary: form.dictionary
    }
  end
end