# frozen_string_literal: true

FactoryBot.define do
  factory(:user) do
    user_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { @pass = Faker::Internet.password }
    password_confirmation { @pass }
    activation_state { 'active' }

    after(:create, &:activate!)

    trait :admin do
      admin { true }
    end
  end

  factory(:pending_user, class: 'User') do
    email { Faker::Internet.email }
    password { @pass = Faker::Internet.password }
    password_confirmation { @pass }
  end

  factory(:dictionary) do
    name { Faker::Lorem.word }

    trait :with_items do
      transient do
        item_count { 2 }
      end

      after(:create) do |dictionary, evaluator|
        create_list(
          :dictionary_item,
          evaluator.item_count,
          dictionary: dictionary
        )
      end
    end
  end

  factory(:dictionary_item) do
    name { Faker::Lorem.word }
    dictionary
  end
end