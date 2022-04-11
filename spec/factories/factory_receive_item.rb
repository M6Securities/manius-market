# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :receive_item do
    association :receive
    association :product

    quantity { Faker::Number.number(digits: 2) }
  end
end
