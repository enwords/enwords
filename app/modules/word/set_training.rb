class Word::SetTraining < ActiveInteraction::Base
  array  :word_ids
  string :training_type
  object :user

  validates :word_ids, :training_type, :user, presence: true

  def execute
    case training_type
    when 'to_training'
      user.update(last_training_type: :training)
    when 'to_training_spelling'
      user.update(last_training_type: :training_spelling)
    else
      raise "Unknown training type #{training_type}"
    end

    update_learned_words_count
    update_studying_words
    update_studying_sentences
  end

  private

  def update_learned_words_count
    counter = user.words.where(language: user.learning_language, word_statuses: { learned: true }).count
    user.update(learned_words_count: counter)
  end

  def studying_words
    @_studying_words ||= Word.where(id: word_ids)
  end

  def update_studying_words
    user.studying_words = studying_words
  end

  def update_studying_sentences
    ids_bunch = user.diversity_enable ? sentences_per_word_diversity : sentences_per_word
    sentences_ids = ids_bunch.flat_map { |m| m['array_agg'].sample(user.sentences_number) }.uniq
    user.studying_sentences = Sentence.find(sentences_ids)
  end

  def sentences_per_word
    Sentence.select('(array_agg(DISTINCT(sentences.id)))[1:100]').joins(:sentences_words).joins(:translations)
            .where(sentences_words:        { word: studying_words },
                   translations_sentences: { language: user.native_language })
            .group('sentences_words.word_id')
  end

  def sentences_per_word_diversity
    Sentence.select('(array_agg(DISTINCT(sentences.id)))[1:100]').joins(:sentences_words)
            .where(sentences_words: { word_id: studying_words }).group('sentences_words.word_id')
  end
end
