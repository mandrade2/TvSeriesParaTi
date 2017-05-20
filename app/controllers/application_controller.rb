class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name username avatar])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[name username avatar])
  end
end
