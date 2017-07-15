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
    word_ids = Hash[Article.find(article).frequency.sort_by { |k, v| v }.reverse].keys
    Word.where(id: word_ids)
        .where.not(id: WordStatus.select(:word_id).where(user: user, learned: true))
        .order("position(id::text in '#{word_ids.join(', ')}')")
  end

  def available
    Word.where(language: user.learning_language).group(:id).order(:id)
  end

  def learned
    user.words.where(language: user.learning_language).where(word_statuses: { learned: true }).order(:id)
  end

  def learning
    user.words.where(language: user.learning_language).where(word_statuses: { learned: false }).order(:id)
  end

  def unknown
    Word.where(language: user.learning_language)
        .where.not(id: WordStatus.select(:word_id).where(user: user)).group(:id).order(:id)
  end

  def searching
    Word.where(language: user.learning_language)
        .where('word LIKE ?', "%#{search.strip.downcase}%").group(:id).order(:id)
  end

  def admining
    Word.all.order(:id)
  end

  def skyeng
    skyeng_setting = user.skyeng_setting
    skyeng_words = Api::Skyeng.learning_words(email: skyeng_setting.try(:email),
                                              token: skyeng_setting.try(:token))
    Word.where(language: user.learning_language,
               word:     skyeng_words)
        .order(:id)
  end
end
