module App
  module SiteAdmin
    class SettingsController < SiteAdminController
      def update
        safe_params = params.require('update').permit(Setting::KEYS)

        Setting::BOOLEAN_KEYS.each do |key|
          safe_params[key] = safe_params[key] == 'on'
        end

        Setting.first.update safe_params

        flash[:success] = 'Settings updated'
        render :edit
      end
    end
  end
end
