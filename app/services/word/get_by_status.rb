class Word::GetByStatus < ActiveInteraction::Base
  object :user
  string :status,  default: nil
  string :search,  default: nil
  string :article, default: nil

  validates :user, presence: true

  def execute
    if status
      case status
      when 'learning'  then learning
      when 'learned'   then learned
      when 'unknown'   then unknown
      when 'available' then available
      when 'skyeng'    then skyeng
      end
    elsif search       then searching
    elsif article      then words_from_article
    elsif user.admin?  then admining
    end
  end

  private

  def words_from_article
    @_words_from_article ||= begin
      word_ids = Hash[Article.find(article).frequency.sort_by { |_k, v| v }.reverse].keys

      available.where(id: word_ids)
               .where.not(id: learned)
               .order("position(id::text in '#{word_ids.join(', ')}')")
    end
  end

  def available
    @_available ||=
      Word.where(language: user.learning_language).where.not(id: offset_words)
  end

  def learned
    @_learned ||=
      available.where(id: WordStatus.select(:word_id).where(user: user, learned: true)).order(:id)
  end

  def learning
    @_learning ||=
      available.where(id: WordStatus.select(:word_id).where(user: user, learned: false)).order(:id)
  end

  def unknown
    @_unknown ||=
      available.where.not(id: WordStatus.select(:word_id).where(user: user)).order(:id)
  end

  def searching
    @_searching ||=
      available.where('word LIKE ?', "#{search.strip.downcase}%").order(:id)
  end

  def offset_words
    @_offset_words ||= Word.where(language: user.learning_language)
                           .order(:id)
                           .limit(user.proficiency_level)
  end

  def admining
    Word.all.order(:id)
  end

  def skyeng
    skyeng_words = Api::Skyeng.learning_words(
      email: user.skyeng_setting.email,
      token: user.skyeng_setting.token
    )
    available.where(word: skyeng_words.flat_map(&:split).uniq).order(:id)
  end
end
