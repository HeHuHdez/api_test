# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'apitest123' }
    password_confirmation { 'apitest123' }
    auth_token { nil }
    expires_at { Time.zone.now }
  end
end
