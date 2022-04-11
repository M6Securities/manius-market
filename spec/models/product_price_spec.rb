# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductPrice, type: :model do
  before(:all) do
    @product_price = FactoryBot.create(:product_price)
  end

  it 'has a valid factory' do
    expect(@product_price).to be_valid
  end

  it 'can not have a negative price' do
    product_price = FactoryBot.build(:product_price, price_cents: (-1 * Faker::Number.number(digits: 4)))
    expect(product_price).to_not be_valid
  end

  it 'is monetized' do
    price_cents = Faker::Number.number(digits: 4)
    product_price = FactoryBot.build(:product_price, price_cents:)

    money = Money.new(price_cents, 'USD')

    expect(product_price.price == money).to be_truthy
  end
end
