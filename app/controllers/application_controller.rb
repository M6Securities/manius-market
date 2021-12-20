# frozen_string_literal: true

# root controller
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :turbo_frame_request_variant

  def check_user_enabled
    render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.enabled
  end

  def after_sign_in_path_for(_resource)
    app_path # your path
  end

  def check_user_site_admin
    render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?
  end

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def default_url_options
    { locale: I18n.locale }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:display_name])
  end

  private

  # from here:
  # https://www.colby.so/posts/turbo-frames-on-rails
  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

end
