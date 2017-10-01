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
    @_sentence_ids ||= begin
      ids_bunch = user.diversity_enable ? sentences_per_word_diversity : sentences_per_word
      ids_bunch.flat_map { |m| m['array_agg'].sample(user.sentences_number) }.uniq
    end
  end

  def sentences_per_word
    result = Sentence.select('(array_agg(DISTINCT(sentences.id)))[1:100]')
                     .joins(:sentences_words)
                     .joins(:translations)
                     .where(language:               user.learning_language,
                            sentences_words:        { word:     word_ids },
                            translations_sentences: { language: user.native_language })
                     .group('sentences_words.word_id')

    return result if result.any?
    sentences_per_word_diversity
  end

  def sentences_per_word_diversity
    Sentence.select('(array_agg(DISTINCT(sentences.id)))[1:100]')
            .joins(:sentences_words)
            .where(language:        user.learning_language,
                   sentences_words: { word_id: word_ids })
            .group('sentences_words.word_id')
  end
end
