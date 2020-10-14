module ApplicationHelper
  def space_title
    t('landings.space.title', lang: t('languages')[params[:l]&.to_sym] || t('landings.space.any'))
  end

  def space_body
    langs = %i[eng deu spa fra ita]
    langs[0] = params[:l].to_sym if params[:l]
    t('landings.space.body', langs: t('languages').slice(*langs).values.join(' '))
  end

  def words_page_title
    if params[:status]
      case params[:status]
      when 'learning' then t 'words.learning'
      when 'learned'  then t 'words.learned'
      when 'unknown'  then t 'words.unknown'
      when 'all'      then t 'words.all'
      when 'skyeng'   then t 'words.skyeng'
      end
    elsif params[:search]
      t 'words.search_result'
    elsif params[:article]
      t 'words.words_of_text'
    end
  end

  def word_color_class(word)
    return if %w[unknown learning learned].include? params[:status]
    return 'learned' if @learned_ids.include?(word.id)
    return 'learning' if @learning_ids.include?(word.id)
  end

  def l_lang
    current_user&.learning_language
  end

  def n_lang
    current_user&.native_language
  end

  def lang_pair
    [l_lang, n_lang]
  end

  def supported_pair?
    Rails.configuration.languages['locales'][l_lang] &&
      Rails.configuration.languages['locales'][n_lang]
  end

  def may_split_sentence?
    supported_pair? && %w[heb ara jpn cmn].exclude?(l_lang)
  end

  def actual_skyeng_setting_path
    current_user.skyeng_setting.present? ? skyeng_setting_path : new_skyeng_setting_path
  end

  def bootstrap_flash_key(key)
    case key
    when 'notice', 'success' then 'success'
    when 'alert', 'error'    then 'warning'
    end
  end
end
