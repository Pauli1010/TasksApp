# frozen_string_literal: true

module Admin
  class DestroyUser < Admin::DestroyItem
    def call
      return broadcast(:invalid) if item == user

      super
    end
  end
end