module Grammar::Eng
  class IdiomsController < ApplicationController
    before_action :authenticate_user!

    def index
      result =
        case params[:status]
        when 'learning' then idioms.where.not(id: user_idioms.select(:idiom_id))
        when 'learned' then idioms.where(id: user_idioms.select(:idiom_id))
        else idioms
        end
      render :index, locals: { idioms: result.paginate(page: params[:page] || 1, per_page: 20) }
    end

    def change_status
      ids = params[:ids] || []
      case params[:commit]
      when 'learned'
        ids.each { |id| Grammar::Eng::UserIdiom.create(user: current_user, idiom_id: id) }
      when 'learning'
        Grammar::Eng::UserIdiom.where(user: current_user, idiom_id: ids).delete_all
      end
      redirect_back(fallback_location: root_path)
    end

    private

    def idioms
      @idioms ||= Grammar::Eng::Idiom.all.order(weight: :desc, value: :asc)
    end

    def user_idioms
      @user_idioms ||= Grammar::Eng::UserIdiom.where(user: current_user)
    end
  end
end
