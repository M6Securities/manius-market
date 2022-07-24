# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  before(:all) do
    @order = FactoryBot.create(:order)
  end

  it 'has a valid factory' do
    expect(@order).to be_valid
  end

  it 'is invalid without a customer' do
    order = FactoryBot.build(:order, customer: nil)
    expect(order).to_not be_valid
  end
end
