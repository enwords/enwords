class SkyengController < ApplicationController
  def first_meaning
    response = Api::Skyeng.first_meaning(word: word_value)
    update_transcription(response)
    response ||= yandex_translate

    if response.present?
      render json: response, status: :ok
    else
      render json: response, status: :unprocessable_entity
    end
  end

  private

  def word_value
    @word_value ||= params[:word].gsub(/\W/, '').downcase
  end

  def yandex_translate
    trans = YANDEX_TRANSLATOR.translate word_value, from: 'en', to: 'ru'

    {
      translation: { text: trans },
      text: word_value
    }
  end

  def update_transcription(response)
    word = Word.find_by(language: :eng, value: word_value)
    return unless response['transcription'].present? && word.transcription.blank?

    word.update!(transcription: response['transcription'])
  end
end
