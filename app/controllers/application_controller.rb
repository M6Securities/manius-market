class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?


  def check_user_enabled
    render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.enabled
  end

  def after_sign_in_path_for(_resource)
    app_root_path # your path
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path
    # destroy_user_session_path
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

  def authenticate_user!
    if user_signed_in?
      super
    else
      render 'sessions/destroy', layout: 'devise'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:display_name])
  end

end
