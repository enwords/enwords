class Training::Create < ActiveInteraction::Base
  array   :word_ids
  string  :training_type
  object  :user
  integer :words_learned, default: 0

  validates :word_ids, :training_type, :user, :words_learned, presence: true
  validate :check_training_type

  def execute
    training.update_attributes\
      training_type: training_type,
      word_ids:      word_ids,
      sentence_ids:  sentence_ids,
      words_learned: words_learned
  end

  private

  def training
    @_training ||= Training.where(user: user).first_or_initialize
  end

  def check_training_type
    errors.add :training, 'Unknown training type' unless Training::TRAINING_TYPES.include? training_type
  end

  def sentence_ids
    result = word_ids.map do |w_id|
      word = Word.find(w_id)

      if user.diversity_enable? || sentences_of_word(word).blank?
        word.sentences.pluck(:id)
      else
        sentences_of_word(word).pluck(:id)
      end
    end

    result.flat_map { |arr| arr.sample(user.sentences_number) }.uniq
  end

  def sentences_of_word(word)
    word.sentences
        .left_joins(:translations)
        .where(translations_sentences: { language: user.native_language })
  end
end
