module ApplicationHelper
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

  def body_class
    lang_pair.join('-') if current_user
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
