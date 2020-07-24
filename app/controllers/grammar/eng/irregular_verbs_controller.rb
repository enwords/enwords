module Grammar::Eng
  class IrregularVerbsController < ApplicationController
    before_action :authenticate_user!

    def index
      result =
        case params[:status]
        when 'learning' then irregular_verbs.where.not(id: user_irregular_verbs.select(:irregular_verb_id))
        when 'learned' then irregular_verbs.where(id: user_irregular_verbs.select(:irregular_verb_id))
        else irregular_verbs
        end
      infinitives = Grammar::Eng::IrregularVerb.select(:infinitive)
      words = Word.where(value: infinitives).order(:id).pluck(:value)
      @irregular_verbs =
        result.sort_by { |v| words.index(v.infinitive) }.paginate(page: params[:page] || 1, per_page: 20)
    end

    def change_status
      ids = params[:ids] || []
      case params[:commit]
      when 'learned'
        ids.each { |id| Grammar::Eng::UserIrregularVerb.create(user: current_user, irregular_verb_id: id) }
      when 'learning'
        Grammar::Eng::UserIrregularVerb.where(user: current_user, irregular_verb_id: ids).delete_all
      when 'grammar'
        return create_training
      end
      redirect_back(fallback_location: root_path)
    end

    private

    def create_training
      fetching = Grammar::Eng::IrregularVerb::FetchTrainingData.run(
        user: current_user,
        verb_ids: params[:ids],
        training_type: 'grammar',
        words_learned: @learned_words_count
      )
      if fetching.valid?
        Training::Create.run!(fetching.result)
        redirect_to training_path
      else
        redirect_back(fallback_location: root_path, alert: t('words.buttons.select_words'))
      end
    end

    def irregular_verbs
      @irregular_verbs ||= Grammar::Eng::IrregularVerb.all
    end

    def user_irregular_verbs
      @user_irregular_verbs ||= Grammar::Eng::UserIrregularVerb.where(user: current_user)
    end
  end
end
