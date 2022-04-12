# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :market do
    display_name { Faker::Company.name }
    path_name { Faker::Name.first_name.downcase }
    email { Faker::Internet.email }

    stripe_publishable_key { Rails.application.credentials.stripe[:publishable_key] }
    stripe_secret_key { Rails.application.credentials.stripe[:secret_key] }
    stripe_webhook_secret { Rails.application.credentials.stripe[:webhook_secret] }
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
    market = create { :market }
    customer = FactoryBot.create(:customer, market:)
    product = FactoryBot.create(:product, market:)

    association customer: customer
    association product: product

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
  end

  factory :order_item do
    order = FactoryBot.create(:order)
    product = FactoryBot.create(:product, market: order.market)

    association order: order
    association product: product

    quantity { Faker::Number.number(digits: 2) }
  end
end
