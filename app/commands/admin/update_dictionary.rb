# frozen_string_literal: true

class Admin::UpdateDictionary < Admin::UpdateItem

  private

  def item_attributes
    {
      name: form.name
    }
  end
end