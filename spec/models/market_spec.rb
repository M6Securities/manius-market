# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Market, type: :model do
  before(:all) do
    @market1 = FactoryBot.create(:market)
  end

  it 'has a valid factory' do
    puts @market1.path_name
    expect(@market1).to be_valid
  end

  it 'is invalid without a display name' do
    market = FactoryBot.build(:market, display_name: nil)
    expect(market).to_not be_valid
  end

  it 'is invalid without a path name' do
    market = FactoryBot.build(:market, path_name: nil)
    expect(market).to_not be_valid
  end

  it 'is invalid if path name has uppercase letters' do
    market = FactoryBot.build(:market, path_name: Faker::Name.first_name)
    expect(market).to_not be_valid
  end

  it 'is invalid if path name has numbers' do
    market = FactoryBot.build(:market, path_name: Faker::Name.first_name.downcase + Faker::Number.number(digits: 2).to_s)
    expect(market).to_not be_valid
  end

  it 'is invalid if path name has symbols' do
    market = FactoryBot.build(:market, path_name: Faker::Name.name.tableize)
    expect(market).to_not be_valid
  end

  it 'is invalid if path name has spaces' do
    market = FactoryBot.build(:market, path_name: Faker::Name.first_name.downcase + ' ' + Faker::Name.last_name.downcase)
    expect(market).to_not be_valid
  end
end
