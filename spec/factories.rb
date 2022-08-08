# frozen_string_literal: true

require 'faker'

# I didn't plan on putting all the factories in one file.
# But it turns out it's needed when factories reference other factories, as seen in cart_items and order_items, where both parent objects need to share traits.
# As in a order item's product and order both need to be part of the same market.

# Rubocop: disable Metrics/BlockLength
FactoryBot.define do
  factory :market do
    display_name { Faker::Company.name }
    path_name { Faker::Name.first_name.downcase }
    email { Faker::Internet.email }
  end

  factory :user do
    display_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :user_market_permission do
    association :market
    association :user

    formatted_permissions { UserMarketPermission.format_permissions [UserMarketPermission::OWNER] }
  end

  factory :customer do
    association :market
    association :user

    real { Faker::Boolean.boolean }
  end

  factory :product do
    association :market

    name { Faker::Commerce.product_name }
    sku { Faker::Number.number(digits: 10) }
    stock { Faker::Number.number(digits: 2) }
    description { Faker::Lorem.paragraph }
    shippable { Faker::Boolean.boolean }
    enabled { false } # should be true only if there is a price set
  end

  factory :product_price do
    association :product

    price_cents { Faker::Number.number(digits: 4) }
  end

  factory :receive do
    association :market
    association :user
  end

  factory :receive_item do
    association :receive
    association :product

    quantity { Faker::Number.number(digits: 2) }
  end

  factory :cart_item do
    market = FactoryBot.create(:market)

    association :customer, factory: :customer, market: market
    association :product, factory: :product, market: market

    quantity { Faker::Number.between(from: 1, to: 10) }
  end

  factory :order do
    association :customer

    shipping_name { Faker::Name.name }
    address_line_1 { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    country { Faker::Address.country }

    payment_status { 0 }
    status { 0 }
  end

  factory :order_item do
    market = FactoryBot.create(:market)
    customer = FactoryBot.create(:customer, market:)

    association :order, factory: :order, customer: customer
    association :product, factory: :product, market: market

    quantity { Faker::Number.number(digits: 2) }
  end
end
