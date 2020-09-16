class Sentence < ApplicationRecord
  has_many :sentences_words
  has_many :links, foreign_key: :sentence_1_id
  has_many :words, through: :sentences_words
  has_many :translations, through: :links, source: :translation

  def audio_url
    if with_audio?
      "https://audio.tatoeba.org/sentences/#{language}/#{id}.mp3"
    elsif language == 'eng'
      ENV['ENG_SOUND_URL'] + value
    end
  end
end
