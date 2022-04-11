# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  before(:all) do
    @customer = FactoryBot.create(:customer)
  end

  it 'has a valid factory' do
    expect(@customer).to be_valid
  end

  it 'is invalid without a market' do
    customer = FactoryBot.build(:customer, market: nil)
    expect(customer).to_not be_valid
  end

  it 'is valid with an email' do
    customer = FactoryBot.build(:customer)
    customer.email = customer.user.email
    expect(customer).to be_valid
  end
end
