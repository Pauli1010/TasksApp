# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  def destroyable?
    true
  end
end
