# frozen_string_literal: true

FactoryBot.define do
  factory(:user) do
    email { Faker::Internet.email }
    password { @pass = Faker::Internet.password }
    password_confirmation { @pass }
  end
end