# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:all) do
    @product1 = FactoryBot.create(:product)
  end

  it 'has a valid factory' do
    expect(@product1).to be_valid
  end

  it 'has a unique sku to the market' do
    product2 = FactoryBot.build(:product, sku: @product1.sku, market: @product1.market)
    expect(product2).to_not be_valid
  end

  it 'is invalid without a name' do
    product2 = FactoryBot.build(:product, name: nil)
    expect(product2).to_not be_valid
  end

  it 'is invalid without a sku' do
    product2 = FactoryBot.build(:product, sku: nil)
    expect(product2).to_not be_valid
  end

  it 'is invalid without a description' do
    product2 = FactoryBot.build(:product, description: nil)
    expect(product2).to_not be_valid
  end
end
