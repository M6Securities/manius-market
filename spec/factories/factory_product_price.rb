# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :product_price do
    association :product

    price_cents { Faker::Number.number(digits: 4) }
  end
end
