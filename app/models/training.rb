class Training < ApplicationRecord
  belongs_to :user

  store_accessor :data,
                 :word_ids,
                 :sentence_ids

  def sentences
    Sentence.where(id: sentence_ids).order(:id)
  end

  def words
    Word.where(id: word_ids).order(:id)
  end
end
