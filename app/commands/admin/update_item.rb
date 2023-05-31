# frozen_string_literal: true

class Admin::UpdateItem < Rectify::Command
  def initialize(form, item, user)
    @form = form
    @item = item
    @user = user
  end

  def call
    return broadcast(:invalid) if form.invalid?

    transaction do
      update_item
    end

    broadcast(:ok, item)
  end

  private

  attr_reader :form, :user, :item

  def update_item
    item.update(item_attributes)
  end

  def item_attributes
    raise NotImplementedError
  end
end