# frozen_string_literal: true

module Admin
  class UpdateUser < Admin::UpdateItem
    private

    def item_attributes
      {
        first_name: form.first_name,
        last_name: form.last_name,
        user_name: form.user_name,
        admin: form.admin
      }
    end
  end
end