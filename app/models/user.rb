# frozen_string_literal: true

# User is a model that holds logic to maintain Users
class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password_confirmation

  has_many :tasks, dependent: :destroy

  def activation_state_pending?
    activation_state == 'pending'
  end

  def destroyable?
    !admin?
  end
end
