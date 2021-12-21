# frozen_string_literal: true

module App
  module SiteAdmin
    class MenuComponent < ViewComponent::Base

      def initialize(current_user)
        super
        @user = current_user
      end

      def render?
        @user.permission? # it'll return true if the user is a site admin
      end

    end
  end
end
