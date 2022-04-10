# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user_market_permission do
    association :market
    association :user

    formatted_permissions { UserMarketPermission.format_permissions [UserMarketPermission::OWNER] }
  end
end
