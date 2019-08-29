class Sentence < ApplicationRecord
  class ByTense < ActiveInteraction::Base
    PRESENT_TENSES = %w[
      present_simple
      present_continuous
      present_perfect
      present_perfect_continuous
    ].freeze

    PAST_TENSES = %w[
      past_simple
      past_continuous
      past_perfect
      past_perfect_continuous
    ].freeze

    FUTURE_TENSES = %w[
      future_simple
      future_continuous
      future_perfect
      future_perfect_continuous
    ].freeze

    TENSES = PRESENT_TENSES + PAST_TENSES + FUTURE_TENSES

    PRONOUNS = %w[
      I
      You
      He
      She
      It
      We
      They
    ].freeze

    AUXILIARY_CONTINUOUS_VERBS =%w[
      am
      is
      are
    ].freeze

    AUXILIARY_PERFECT_VERBS =%w[
      was
      were
    ].freeze

    # am, is, are, was, were, being, been are different tenses of the verb

    object :user
    string :tense

    validates :tense, inclusion: { in: TENSES }

    def execute
      send tense
    end

    private

    def present_simple
      sentences.where('')
      S + V1(s/es) + O
    end

    def sentences
      Sentence.includes(:translations)
              .where(language:               user.learning_language,
                     translations_sentences: { language: user.native_language })
              .where('sentences.id > ?', rand(10**3..(10**6.7).round))
              .limit(10)
    end

    def irregular_verbs
      @_irregular_verbs ||= Grammar::Eng::IrregularVerb.all
    end

    def irregular_infinitive
      @_irregular_infinitive ||=
        irregular_verbs.flat_map(&:infinitive)
    end

    def irregular_simple_past
      @_irregular_simple_past ||=
        irregular_verbs.flat_map(&:simple_past).flatten
    end

    def irregular_past_participle
      @_irregular_past_participle ||=
        irregular_verbs.flat_map(&:past_participle).flatten
    end
  end
end
