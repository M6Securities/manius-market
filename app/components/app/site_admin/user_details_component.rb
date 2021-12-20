# frozen_string_literal: true

module App
  module SiteAdmin
    class UserDetailsComponent < ViewComponent::Base
      def initialize(user)
        super
        @user = user
      end
    end
  end
end
