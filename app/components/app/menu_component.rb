# frozen_string_literal: true

module App
  class MenuComponent < ViewComponent::Base

    def initialize(user)
      super
      @user = user
    end

    def render?
      super

      return false if @user.nil?

      true
    end

  end
end
