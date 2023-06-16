# frozen_string_literal: true

module Admin
  class CreateDictionary < Admin::CreateItem
    private

    def item_attributes
      {
        name: form.name
      }
    end

    def item_class
      ::Dictionary
    end
  end
end