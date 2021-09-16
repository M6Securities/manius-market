# frozen_string_literal: true

module App
  class SiteAdminController < AppController
    layout 'site_admin'

    before_action :check_user_site_admin
  end
end
