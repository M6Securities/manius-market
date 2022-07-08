# frozen_string_literal: true

require 'test_helper'

module App
  module MarketSpace
    class MarketControllerTest < ActionDispatch::IntegrationTest
      include Devise::Test::IntegrationHelpers
      test 'check_current_market' do
        sign_in users(:system)
        get app_market_space_market_index_url
      end

      test 'should get new' do
        sign_in users(:system)

        puts Market.all.size

        get new_app_market_space_market_url
        puts @response.body

        assert_equal 'new', @controller.action_name
        # assert_equal 'application/x-www-form-urlencoded', @request.media_type
      end
    end
  end
end
