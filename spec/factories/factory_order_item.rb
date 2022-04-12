# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :order_item do
    order = FactoryBot.create(:order)
    product = FactoryBot.create(:product, market: order.market)

    association order: order
    association product: product

    quantity { Faker::Number.number(digits: 2) }
  end
end
