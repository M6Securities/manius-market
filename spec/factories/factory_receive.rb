# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :receive do
    association :market
    association :user
  end
end
