class API::Web::TranslationsController < ::API::BaseController
  def index
    result = decorate
    if result.present?
      render json: result, status: :ok
    else
      render json: result, status: :unprocessable_entity
    end
  end

  private

  def youglish
    accent = User::Languages::LOCALES[params[:from].to_sym]
    return unless accent

    lang = User::Languages::YOUGLISH_ACCENTS[accent]
    return unless lang

    {
      accent: accent,
      lang: lang
    }
  end

  def word_value
    @word_value ||= params[:word].downcase.strip
  end

  def skyeng_translate
    @skyeng_translate ||= begin
      return unless params[:from] == 'eng' && params[:to] == 'rus'

      result = API::Skyeng.first_meaning(word: word_value)
      return if result.blank?

      update_trans(result.dig('translation', 'text'))
      update_sound_url(result.dig('soundUrl'))
      result
    end
  end

  def yandex_translate
    @yandex_translate ||= begin
      from = User::Languages::LOCALES[params[:from].to_sym]
      to = User::Languages::LOCALES[params[:to].to_sym]
      result = API::YandexTranslate.translate(text: word_value, from: from, to: to)
      update_trans(result)
      result
    end
  end

  def decorate
    return unless word

    {
      translation: word.data&.dig('trans', params[:to]) || yandex_translate || skyeng_translate&.dig('translation', 'text'),
      transcription: word.transcription,
      text: word.value,
      sound_url: word.data&.dig('sound_url') || skyeng_translate&.dig('soundUrl'),
      youglish: youglish
    }
  end

  def update_trans(trans)
    return unless word && trans
    return if word.data&.dig('trans', params[:to])

    data = word.data || {}
    data['trans'] ||= {}
    data['trans'][params[:to]] = trans
    word.update!(data: data)
  end

  def update_sound_url(sound_url)
    return unless word && sound_url
    return if word.data&.dig('sound_url')

    data = word.data || {}
    data['sound_url'] = sound_url
    word.update!(data: data)
  end

  def word
    @word ||= Word.find_by(language: params[:from], value: word_value)
  end
end
