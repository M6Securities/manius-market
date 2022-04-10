# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user1 = FactoryBot.create(:user)
  end

  it 'has a valid factory' do
    expect(@user1).to be_valid
  end
end
