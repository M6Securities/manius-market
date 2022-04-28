require 'rails_helper'

RSpec.describe 'Root page', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @market = FactoryBot.create(:market)
    @market = Market.first
  end

  it 'has a title' do
    visit '/'

    # save_and_open_page

    expect(page).to have_text Setting.all.first.app_name
  end
end
