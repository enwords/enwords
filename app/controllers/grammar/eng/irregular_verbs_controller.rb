module Grammar
  module Eng
    class IrregularVerbsController < ApplicationController
      def index
        @irregular_verbs =
          Grammar::Eng::IrregularVerb.all.paginate(page: params[:page], per_page: 20)
      end

      def create_training
        verbs = Grammar::Eng::IrregularVerb.where(id: params[:ids])

        if verbs.any?
          words =
            verbs.pluck(:infinitive, :simple_past, :past_participle).flatten

          ids = Word.where(word: words).pluck(:id)

          Training::Create.run(word_ids:      ids,
                               training_type: 'repeating',
                               user:          current_user,
                               words_learned: @learned_words_count)
          redirect_to training_path
        else
          redirect_to :back
        end
      end
    end
  end
end
