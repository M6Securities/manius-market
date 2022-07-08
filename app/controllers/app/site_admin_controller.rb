# frozen_string_literal: true

module App
  # everything past here is for site admins only
  class SiteAdminController < AppController
    layout :set_layout

    before_action :check_user_site_admin

    def set_layout
      return 'turbo_frame' if turbo_frame_request?

      'site_admin'
    end
  end
end
