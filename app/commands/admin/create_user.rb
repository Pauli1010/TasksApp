# frozen_string_literal: true

module Admin
  class CreateUser < Admin::CreateItem
    def call
      return broadcast(:invalid) if form.invalid?

      transaction do
        create_item
      end

      broadcast(:ok, item)
    end

    private

    def item_attributes
      {
        email: form.email,
        first_name: form.first_name,
        last_name: form.last_name,
        user_name: form.user_name,
        admin: form.admin
      }
    end

    def item_class
      User
    end
  end
end