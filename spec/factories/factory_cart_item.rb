# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :cart_item do
    association :customer
    association :product

    quantity { Faker::Number.between(from: 1, to: 10) }
  end
end
