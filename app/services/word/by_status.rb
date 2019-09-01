class Word < ApplicationRecord
  class ByStatus < ActiveInteraction::Base
    private

    object :user
    string :status,  default: nil
    string :search,  default: nil
    string :article, default: nil

    def execute
      result =
        if status
          case status
          when 'learning' then learning
          when 'learned' then learned
          when 'unknown' then unknown
          when 'available' then available
          when 'skyeng' then skyeng
          end
        elsif search then searching
        elsif article then words_from_article
        end
      result = result.order(:weight)
      result
    end

    def offset_word
      Word.where(language: user.learning_language).offset(user.proficiency_level.to_i).order(:weight).first
    end

    def available
      Word.where(language: user.learning_language).where('words.weight >= ?', offset_word.weight)
    end

    def words_from_article
      word_ids =
        Hash[Article.find(article).frequency.sort_by { |_k, v| v }.reverse].keys
      available
        .where(id: word_ids)
        .where.not(id: learned)
        .order("position(id::text in '#{word_ids.join(', ')}')")
    end

    def learned
      filter_words_by_status(available, true)
    end

    def learning
      filter_words_by_status(available, false)
    end

    def filter_words_by_status(relation, learned)
      relation
        .joins(<<~SQL)
          JOIN word_statuses
          ON word_statuses.word_id = words.id
          AND word_statuses.user_id = #{user.id}
          AND learned = #{learned}
        SQL
    end

    def unknown
      available
        .joins(<<~SQL)
          LEFT JOIN word_statuses
          ON word_statuses.word_id = words.id
          AND word_statuses.user_id = #{user.id}
        SQL
        .where(word_statuses: { user_id: nil })
    end

    def searching
      available.where('value LIKE ?', "#{search.strip.downcase}%")
    end

    def skyeng
      result = Rails.cache.read("skyeng_words_user_#{user.id}")
      return result if result

      skyeng_words = Api::Skyeng.learning_words(
        email: user.skyeng_setting.email,
        token: user.skyeng_setting.token
      )
      result = available.where(value: skyeng_words).where.not(id: 1..100)
      user.update!(skyeng_words_count: result.size)

      return result if result.size < 100

      Rails.cache.write("skyeng_words_user_#{user.id}", result, expires_in: 1.hour)
      result
    end
  end
end
