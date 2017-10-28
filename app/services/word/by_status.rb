class Word < ApplicationRecord
  class ByStatus < ActiveInteraction::Base
    object :user
    string :status,  default: nil
    string :search,  default: nil
    string :article, default: nil

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
        word_ids = Hash[Article.find(article)
                               .frequency.sort_by { |_k, v| v }.reverse].keys

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
        available.where(id: WordStatus.select(:word_id)
                                      .where(user: user, learned: true)).order(:id).to_a
    end

    def learning
      @_learning ||=
        available.where(id: WordStatus.select(:word_id).where(user: user, learned: false))
                 .order(:id).to_a
    end

    def unknown
      @_unknown ||=
        available.where.not(id: WordStatus.select(:word_id).where(user: user)).order(:id).to_a
    end

    def searching
      @_searching ||=
        available.where('word LIKE ?', "#{search.strip.downcase}%").order(:id).to_a
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
      result = Rails.cache.read("skyeng_words_user_#{user.id}")
      return result if result

      skyeng_words = Api::Skyeng.learning_words \
        email: user.skyeng_setting.email,
        token: user.skyeng_setting.token

      result = available.where(word: skyeng_words).where.not(id: 1..100).order(:id).to_a
      user.update(skyeng_words_count: result.size)

      return result if result.size < 100

      Rails.cache.write("skyeng_words_user_#{user.id}", result, expires_in: 1.hour)
      result
    end
  end
end
