class OtherArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: %i[show]

  def index
    @articles =
      Article.where(language: current_user.learning_language)
             .where(user_id: 2)
             .order(:id)
             .paginate(page: params[:page], per_page: 20)
  end

  def show; end

  private

  def set_article
    @article = Article.find(params[:id])
  end
end
