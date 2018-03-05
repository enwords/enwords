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

    def present_continuous

    end

    def present_perfect

    end

    def present_perfect_continuous

    end

    # def present_simple
    #   @_present_simple ||=
    #     sentences.where("sentences.sentence NOT ILIKE '%will%'")
    #              .where("sentences.sentence NOT ILIKE '%have%'")
    #              .where("sentences.sentence NOT ILIKE '%has%'")
    #              .where("sentences.sentence NOT ILIKE '%had%'")
    #              .where("sentences.sentence NOT ILIKE '%was%'")
    #              .where("sentences.sentence NOT ILIKE '%were%'")
    #              .where("sentences.sentence NOT ILIKE '%did%'")
    #              .where("sentences.sentence NOT ILIKE '%ing%'")
    #              .where("sentences.sentence NOT ILIKE '%am%'")
    #              .where("sentences.sentence NOT ILIKE '%is%'")
    #              .where("sentences.sentence NOT ILIKE '%are%'")
    #              .where("sentences.sentence NOT ILIKE '%''%'")
    #              .where("sentences.sentence NOT ILIKE '%ed %'")
    #              .where('sentences.sentence NOT SIMILAR TO ?',
    #                     "%(#{(irregular_simple_past + irregular_past_participle).join('|')})%")
    #              .where('LOWER(sentences.sentence) SIMILAR TO ?',
    #                     '(i|you|he|she|it|we|they) %')
    #
    # end
    #
    # def present_continuous
    #   @_present_continuous ||=
    #     sentences.where("sentences.sentence ILIKE '%ing %'")
    #              .where('LOWER(sentences.sentence) SIMILAR TO ?',
    #                     '(i|you|he|she|it|we|they) %')
    #              .where('LOWER(sentences.sentence) SIMILAR TO ?',
    #                     '% (am|are|is|) %')
    #              .where('sentences.sentence NOT SIMILAR TO ?',
    #                     "%(#{(irregular_simple_past + irregular_past_participle).join('|')})%")
    # end
    #
    # def present_perfect
    #   @_present_perfect ||=
    #     sentences.where("sentences.sentence LIKE '%ed %'")
    #              .where('LOWER(sentences.sentence) SIMILAR TO ?',
    #                     '(i|you|he|she|it|we|they) %')
    #              .where('LOWER(sentences.sentence) SIMILAR TO ?',
    #                     '% (has|have) %')
    #              .where('LOWER(sentences.sentence) NOT SIMILAR TO ?',
    #                     '% (has a|have a) %')
    #              .where('sentences.sentence LIKE ?',
    #                     '%ed %')
    #              .where('sentences.sentence NOT LIKE ?',
    #                     '% been %')
    #              .where('sentences.sentence NOT LIKE ?',
    #                     '%s %')
    #              .where('sentences.sentence NOT SIMILAR TO ?',
    #                     "%(#{(irregular_simple_past).join('|')})%")
    # end

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

# REGULARKIII!!!

# formula of tenses
#
# Present Tense
#
# 1. Simple Present Tense
# S + V1(s/es) + O
# 2. Present Continuous Tense
# S + is,am,are + V-ing + O
# 3. Present Perfect Tense
# S + has/have + V3 + O
#
# Past Tense
#
# 1. Simple Past Tense
# S + V2 + object
# S + was/were + (adv/adj/noun)
# 2. Past Continuous Tense
# S + was/were + V-ing + O
# 3. Past Perfect Tense
# S + had + V3 + …..
#   4. Past Perfect Continuous Tense
# S + had been + V-ing + for…before…
#
# Future Tense
#
# 1. Present Future Tense
# S + shall/will + V1 (be) + O
# S + to be (am/is/are) + going to + V1(be)
# 2. Present Future Continuous Tense
# S + shall/will + be + V1 ing + O
# 3. Present Future Perfect Tense
# S + shall/will + have + V3 (been) + O
# 4. Present Future Perfect Continuous Tense
# S + shall/will + have been + V-ing + O