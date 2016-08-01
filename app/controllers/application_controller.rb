class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  #Allows to change a profile settings without entering a password
  def configure_devise_permitted_parameters
    registration_params = [:email, :password, :password_confirmation,
                           :learning_language, :native_language, :audio_enable,:diversity_enable, :sentences_number]

    if params[:action] == 'update'
      devise_parameter_sanitizer.permit(:account_update, keys: registration_params << :current_password )
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up, keys: registration_params )
    end
  end
end
