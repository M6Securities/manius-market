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
end
