# frozen_string_literal: true

require 'faker'
# require 'factory_market'

FactoryBot.define do
  factory :cart_item do
    market = create { :market }
    customer = FactoryBot.create(:customer, market:)
    product = FactoryBot.create(:product, market:)

    association customer: customer
    association product: product

    quantity { Faker::Number.between(from: 1, to: 10) }
  end

end
