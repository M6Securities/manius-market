# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartItem, type: :model do
  before(:all) do
    @cart_item = FactoryBot.build(:cart_item)
    @cart_item.product.market = @cart_item.customer.market # cause there's no way to do this in the factory
    @cart_item.save
  end

  it 'has a valid factory' do
    expect(@cart_item).to be_valid
  end

  it 'is invalid without a customer' do
    cart_item = FactoryBot.build(:cart_item, customer: nil)
    expect(cart_item).to_not be_valid
  end

  it 'is invalid without a product' do
    cart_item = FactoryBot.build(:cart_item, product: nil)
    expect(cart_item).to_not be_valid
  end

  it 'is invalid if the product market is different from the customer market' do
    cart_item = FactoryBot.build(:cart_item)
    expect(cart_item).to_not be_valid
  end

  it 'has a valid price' do
    price_cents = Faker::Number.number(digits: 4)
    quantity = Faker::Number.number(digits: 2)

    market = FactoryBot.create(:market)
    product = FactoryBot.create(:product, market:)
    customer = FactoryBot.create(:customer, market:)
    product.product_prices.create(price_cents:)
    cart_item = FactoryBot.create(:cart_item, product:, customer:, quantity:)

    money = Money.new(price_cents * quantity, 'USD')

    expect(cart_item.price_total('USD')).to eq(money)
  end
end
