# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Receive, type: :model do
  before(:all) do
    @receive = FactoryBot.create(:receive)
  end

  it 'has a valid factory' do
    expect(@receive).to be_valid
  end

  it 'is invalid if market is nil' do
    receive = FactoryBot.build(:receive, market: nil)
    expect(receive).to_not be_valid
  end

  it 'is invalid if user is nil' do
    receive = FactoryBot.build(:receive, user: nil)
    expect(receive).to_not be_valid
  end
end
