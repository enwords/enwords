class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :word_statistic, if: :current_user

  def hc
    head :ok
  end

  private

  def word_statistic
    @skyeng_words_count = (current_user.skyeng_words_count || '?' if current_user.skyeng_setting)
    @learning_words_count = Word::ByStatus.run!(status: 'learning', user: current_user).count
    @learned_words_count = Word::ByStatus.run!(status: 'learned', user: current_user).count
    @unknown_words_count = Word::ByStatus.run!(status: 'unknown', user: current_user).count
  end

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options
    { locale: I18n.locale }
  end

  protected

  def configure_devise_permitted_parameters
    registration_params =
      %i[email password password_confirmation learning_language native_language
         audio_enable diversity_enable sentences_number]

    if params[:action] == 'update'
      devise_parameter_sanitizer.permit \
        :account_update, keys: registration_params << :current_password
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up, keys: registration_params)
    end
  end
end
