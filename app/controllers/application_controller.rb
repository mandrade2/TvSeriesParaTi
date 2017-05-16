class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name username])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[name username])
  end

  def logged_in?
    redirect_to(new_user_session_path, notice: 'inicie sesión primero') unless current_user
  end
end
