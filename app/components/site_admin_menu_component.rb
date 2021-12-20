# frozen_string_literal: true

class SiteAdminMenuComponent < ViewComponent::Base

  def initialize(current_user)
    super
    @user = current_user
  end

  def render?
    @user.permission? # it'll return true if the user is a site admin
  end
end
