# frozen_string_literal: true

module Admin
  class UpdateDictionaryItem < Admin::UpdateItem
    private

    def item_attributes
      {
        name: form.name,
        dictionary: form.dictionary
      }
    end
  end
end