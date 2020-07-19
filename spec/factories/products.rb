# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Producto #{n}" }
    description { Faker::Lorem.paragraph }
  end
end
