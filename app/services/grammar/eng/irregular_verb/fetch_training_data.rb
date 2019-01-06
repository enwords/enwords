module Grammar
  module Eng
    class IrregularVerb < ApplicationRecord
      class FetchTrainingData < ActiveInteraction::Base
        object  :user
        array   :verb_ids
        integer :words_learned
        string  :training_type

        validate :check_verbs

        def execute
          {
            user:          user,
            word_ids:      word_ids,
            training_type: training_type,
            words_learned: words_learned
          }
        end

        private

        def word_ids
          Word.where(value:    words,
                     language: user.learning_language).pluck(:id)
        end

        def words
          verbs.pluck(:simple_past, :past_participle).flatten
        end

        def verbs
          @_verbs ||= Grammar::Eng::IrregularVerb.where(id: verb_ids)
        end

        # validations

        def check_verbs
          errors.add :base, 'no verbs' if verbs.blank?
        end
      end
    end
  end
end
