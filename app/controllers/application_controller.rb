class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
 
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :forname
    devise_parameter_sanitizer.for(:sign_up) << :surname
    devise_parameter_sanitizer.for(:sign_up) << :address
    devise_parameter_sanitizer.for(:sign_up) << :phone
    devise_parameter_sanitizer.for(:sign_up) << :is_manager
    devise_parameter_sanitizer.for(:sign_up) << :manager_id
    devise_parameter_sanitizer.for(:sign_up) << :avator
  end

  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end
end
