# frozen_string_literal: true

class Task < ApplicationRecord
  enum :status, { added: 'added', done: 'done' }

  belongs_to :user

  def destroyable?
    true
  end
end
