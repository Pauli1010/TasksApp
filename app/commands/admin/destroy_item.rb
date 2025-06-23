# frozen_string_literal: true

module Admin
  class DestroyItem < Rectify::Command
    def initialize(item, user)
      @item = item
      @user = user
    end

    def call
      return broadcast(:invalid) unless item.destroyable?

      transaction do
        destroy_item
      end

      broadcast(:ok)
    end

    private

    attr_reader :user, :item

    def destroy_item
      item.destroy
    end
  end
end