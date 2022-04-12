# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :order do
    association :customer

    shipping_name { Faker::Name.name }
    address_line_1 { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    country { Faker::Address.country }
  end
end
