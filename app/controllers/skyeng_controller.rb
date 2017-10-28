class SkyengController < ApplicationController
  before_action :set_word

  def first_meaning
    response = Api::Skyeng.first_meaning(word: @word)
    response ||= yandex_translate

    if response.present?
      render json: response, status: :ok
    else
      render json: response, status: :unprocessable_entity
    end
  end

  private

  def set_word
    @word = params[:word].gsub(/\W/, '').downcase
  end

  def yandex_translate
    trans = YANDEX_TRANSLATOR.translate @word, from: 'en', to: 'ru'

    {
      translation: { text: trans },
      text:        @word
    }
  end
end
