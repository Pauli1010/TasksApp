# frozen_string_literal: true

class Admin::CreateDictionary < Admin::CreateItem

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