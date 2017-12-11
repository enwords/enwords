class Article < ApplicationRecord
  belongs_to :user, optional: true

  validates :language, :title, :content, presence: true
  before_save :word_frequency

  store_accessor :words_data,
                 :frequency,
                 :track_id

  private

  def word_frequency
    text            = self.content.downcase.gsub(/[[:punct:]\d\+\$\^\=\–\>\<\~\`\№]/, '')
    words           = text.split(' ')
    words_from_text = words.each_with_object({}) do |word, frequencies|
      begin
        frequencies[word] += 1
      rescue
        frequencies[word] = 1
      end
    end

    words_from_db  = Word.where(word: words_from_text.map(&:first), language: self.language)

    xx = words_from_db.each_with_object({}) do |word, hsh|
      hsh[word.id] = words_from_text[word.word]
    end

    self.words_data['frequency'] = xx
  end
end
