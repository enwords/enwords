class AudioArticlesController < ApplicationController
  before_action :authenticate_user!

  def index
    @articles =
      Article.where(language: current_user.learning_language)
             .where(user_id: 2)
             .order(:id)
             .paginate(page: params[:page], per_page: 20)
  end

  def show
    @article = Article.find(params[:id])
  end
end
