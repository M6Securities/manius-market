# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  before(:all) do
    @order_item = FactoryBot.create(:order_item)
  end

  it 'has a valid factory' do
    expect(@order_item).to be_valid
  end

  it 'is invalid without a order' do
    order_item = FactoryBot.build(:order_item, order: nil)
    expect(order_item).to_not be_valid
  end

  it 'is invalid without a product' do
    order_item = FactoryBot.build(:order_item, product: nil)
    expect(order_item).to_not be_valid
  end

  it 'is invalid without a quantity' do
    order_item = FactoryBot.build(:order_item, quantity: nil)
    expect(order_item).to_not be_valid
  end

  it 'is invalid if the quantity is less than 1' do
    order_item = FactoryBot.build(:order_item, quantity: 0)
    expect(order_item).to_not be_valid
  end
end
