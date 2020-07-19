# frozen_string_literal: true

FactoryBot.define do
  factory :order_product do
    association :order, factory: :order, strategy: :create
    association :product, factory: :product, strategy: :create
    quantity { rand(1..10) }
  end
end
