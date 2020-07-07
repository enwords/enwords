module Grammar::Eng
  class PhrasalVerbsController < ApplicationController
    before_action :authenticate_user!

    def index
      result =
        case params[:status]
        when 'learning' then phrasal_verbs.where.not(id: user_phrasal_verbs.select(:phrasal_verb_id))
        when 'learned' then phrasal_verbs.where(id: user_phrasal_verbs.select(:phrasal_verb_id))
        else phrasal_verbs
        end
      render :index, locals: { phrasal_verbs: result.paginate(page: params[:page] || 1, per_page: 20) }
    end

    def change_status
      ids = params[:ids] || []
      case params[:commit]
      when 'learned'
        ids.each { |id| Grammar::Eng::UserPhrasalVerb.create(user: current_user, phrasal_verb_id: id) }
      when 'learning'
        Grammar::Eng::UserPhrasalVerb.where(user: current_user, phrasal_verb_id: ids).delete_all
      end
      redirect_back(fallback_location: root_path)
    end

    private

    def phrasal_verbs
      @phrasal_verbs ||= Grammar::Eng::PhrasalVerb.all.order(weight: :desc, value: :asc)
    end

    def user_phrasal_verbs
      @user_phrasal_verbs ||= Grammar::Eng::UserPhrasalVerb.where(user: current_user)
    end
  end
end
