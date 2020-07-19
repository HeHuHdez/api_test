# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    name { Faker::Number.number(digits: 10) }
    description { Faker::Lorem.paragraph }
    date { Faker::Time.between(from: DateTime.now - 30, to: DateTime.now, format: :default) }
  end
end
