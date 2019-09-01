class SkyengController < ApplicationController
  def first_meaning
    result = skyeng_translate
    update_transcription(result)
    result = yandex_translate if result.blank?

    if result.present?
      render json: result, status: :ok
    else
      render json: result, status: :unprocessable_entity
    end
  end

  private

  def word_value
    @word_value ||= params[:word].gsub(/\W/, '').downcase
  end

  def skyeng_translate
    Api::Skyeng.first_meaning(word: word_value)
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
    return unless word
    return unless response['transcription'].present? && word.transcription.blank?

    word.update!(transcription: response['transcription'])
  end
end
