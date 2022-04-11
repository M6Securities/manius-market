# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReceiveItem, type: :model do
  before(:all) do
    @receive_item = FactoryBot.create(:receive_item)
  end

  it 'has a valid factory' do
    expect(@receive_item).to be_valid
  end

  it 'is invalid if quantity is negative' do
    receive_item = FactoryBot.build(:receive_item, quantity: -1)
    expect(receive_item).to_not be_valid
  end

  it 'is invalid if product is nil' do
    receive_item = FactoryBot.build(:receive_item, product: nil)
    expect(receive_item).to_not be_valid
  end

  it 'is invalid if receive is nil' do
    receive_item = FactoryBot.build(:receive_item, receive: nil)
    expect(receive_item).to_not be_valid
  end
end
