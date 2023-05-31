# frozen_string_literal: true

class Admin::DestroyItem < Rectify::Command
  def initialize(form, item, user)
    @form = form
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

  attr_reader :form, :user, :item

  def destroy_item
    item.destroy
  end
end