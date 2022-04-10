# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :product do
    association :market

    name { Faker::Commerce.product_name }
    sku { Faker::Number.number(digits: 10) }
    stock { Faker::Number.number(digits: 2) }
    description { Faker::Lorem.paragraph }
    shippable { Faker::Boolean.boolean }
    enabled { false } # should be true only if there is a price set
  end
end
