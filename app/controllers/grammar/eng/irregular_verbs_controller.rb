module Grammar
  module Eng
    class IrregularVerbsController < ApplicationController
      before_action :authenticate_user!

      def index
        infinitives = Grammar::Eng::IrregularVerb.select(:infinitive)
        words = Word.where(value: infinitives).order(:id).pluck(:value)

        @irregular_verbs =
          Grammar::Eng::IrregularVerb.all.sort_by { |v| words.index(v.infinitive) }
                                     .paginate(page: params[:page], per_page: 20)
      end

      def create_training
        fetching = Grammar::Eng::IrregularVerb::FetchTrainingData.run \
          user: current_user,
          verb_ids: params[:ids],
          training_type: params[:commit].gsub(/to_training_/, ''),
          words_learned: @learned_words_count

        if fetching.valid?
          Training::Create.run!(fetching.result)
          redirect_to training_path
        else
          redirect_to :back, alert: t('words.buttons.select_words')
        end
      end
    end
  end
end
