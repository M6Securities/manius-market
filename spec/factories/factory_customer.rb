# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :customer do
    association :market
    association :user

    real { Faker::Boolean.boolean }
  end
end
