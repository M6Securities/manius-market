# frozen_string_literal: true

class Site::NavbarComponent < ViewComponent::Base

  def initialize(user)
    @user = user
  end

end
