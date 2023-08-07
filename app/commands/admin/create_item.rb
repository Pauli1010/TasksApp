# frozen_string_literal: true

module Admin
  class CreateItem < Rectify::Command
    def initialize(form, user)
      @form = form
      @user = user
    end

    def call
      return broadcast(:invalid) if form.invalid?

      transaction do
        create_item
      end

      broadcast(:ok, item)
    end

    private

    attr_reader :form, :user, :item

    def create_item
      @item = item_class.create(item_attributes)
    end

    def item_attributes
      raise NotImplementedError
    end

    def item_class
      raise NotImplementedError
    end
  end
end