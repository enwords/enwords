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

  def body_class
    return if current_user.blank?
    "#{current_user.learning_language}-#{current_user.native_language}"
  end
end
