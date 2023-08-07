# frozen_string_literal: true

module Admin
  class UpdateDictionary < Admin::UpdateItem
    private

    def item_attributes
      {
        name: form.name
      }
    end
  end
end