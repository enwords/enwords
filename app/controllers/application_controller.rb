class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :word_statistic, if: :current_user

  private

  def word_statistic
    @learning_words_count = current_user.words.where(language: current_user.learning_language,
                                                     word_statuses: { learned: false }).count
    @learned_words_count  = current_user.words.where(language: current_user.learning_language,
                                                     word_statuses: { learned: true }).count
    @unknown_words_count  = Word.where(language: current_user.learning_language).count \
                            - (@learning_words_count + @learned_words_count)
  end

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options(options = {})
    { locale: I18n.locale }
  end

  protected

  # Allows to change a profile settings without entering a password
  def configure_devise_permitted_parameters
    registration_params = %i[email password password_confirmation learning_language native_language audio_enable
                             diversity_enable sentences_number]

    if params[:action] == 'update'
      devise_parameter_sanitizer.permit(:account_update, keys: registration_params << :current_password)
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up, keys: registration_params)
    end
  end
end
