# frozen_string_literal: true

FactoryBot.define do
  factory(:user) do
    email { Faker::Internet.email }
    password { @pass = Faker::Internet.password }
    password_confirmation { @pass }
    activation_state { 'active' }

    trait :pending do
      activation_state { 'active' }
      activation_token { Faker::Internet.base64(length: 20) }
    end
  end
end