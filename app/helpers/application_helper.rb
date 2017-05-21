module ApplicationHelper

  def words_page_title
    if params[:status]
      case params[:status]
      when 'learning' then t 'words.learning'
      when 'learned'  then t 'words.learned'
      when 'unknown'  then t 'words.unknown'
      when 'all'      then t 'words.all'
      end
    elsif params[:search]
      t 'words.search_result'
    elsif params[:article]
      t 'words.words_of_text'
    end
  end
end
