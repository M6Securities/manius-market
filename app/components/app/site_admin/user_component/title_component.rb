# frozen_string_literal: true

module App
  module SiteAdmin
    module UserComponent
      class TitleComponent < ViewComponent::Base
        def initialize(user)
          super
          @user = user
        end
      end
    end
  end
end
