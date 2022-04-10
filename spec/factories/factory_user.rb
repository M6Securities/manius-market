# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    display_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
