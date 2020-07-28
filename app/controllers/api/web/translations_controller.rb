class API::Web::TranslationsController < ::API::BaseController
  def index
    if params[:from] == 'eng' && params[:to] == 'rus'
      result = skyeng_translate
    end
    result = yandex_translate if result.blank?
    result.merge!(youglish: youglish)
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
    return
    API::Skyeng.first_meaning(word: word_value)
  end

  def yandex_translate
    from = User::Languages::LOCALES[params[:from].to_sym]
    to = User::Languages::LOCALES[params[:to].to_sym]
    trans = API::YandexTranslate.translate(text: word_value, from: from, to: to)
    if trans && word
      data = word.data || {}
      data['trans'] ||= {}
      data['trans'][params[:to]] = trans
      word.update!(data: data)
    end
    {
      translation: { text: trans },
      transcription: word&.transcription,
      text: word_value
    }
  end

  def word
    @word ||= Word.find_by(language: params[:from], value: word_value)
  end
end
