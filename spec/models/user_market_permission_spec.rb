# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMarketPermission, type: :model do
  before(:all) do
    @user_market_permission = FactoryBot.create(:user_market_permission)
  end

  it 'has a valid factory' do
    expect(@user_market_permission).to be_valid
  end

  it 'is invalid with incorrect permissions' do
    expect(FactoryBot.build(:user_market_permission, formatted_permissions: -1)).to_not be_valid
  end

  it 'is valid with multiple permissions' do
    expect(
      FactoryBot.build(
        :user_market_permission,
        formatted_permissions: UserMarketPermission.format_permissions(
          [
            UserMarketPermission::MEMBER,
            UserMarketPermission::VIEW_PRODUCTS,
            UserMarketPermission::EDIT_CUSTOMERS
          ]
        )
      )
    ).to be_valid
  end
end
