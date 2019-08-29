class Article < ApplicationRecord
  belongs_to :user, optional: true

  validates :language, :title, :content, presence: true
  before_save :calc_word_frequency

  store_accessor :words_data,
                 :frequency,
                 :track_id

  private

  def calc_word_frequency
    text = content.downcase.gsub(/[[:punct:]\d\+\$\^\=\-\>\<\~\`]/, '')
    words = text.split(' ')
    grouped_words = words.each_with_object(Hash.new(0)) { |e, h| h[e] += 1 }
    db_words = Word.where(value: words, language: language)

    words_data['frequency'] = db_words.each_with_object({}) do |word, hsh|
      hsh[word.id] = grouped_words[word.value]
    end
  end
end
