module API::Mobile
  class ArticlesController < BaseController
    def index
      result = current_user.articles
                           .where(language: current_user.learning_language)
                           .order(id: :desc)
                           .paginate(page: params[:page], per_page: 20)
      render json: { collection: result.as_json }, status: :ok
    end

    def create
      result = Article.create!(
        user: current_user,
        language: current_user.learning_language,
        title: params.require(:title),
        content: params.require(:content)
      )
      render json: { resource: result.as_json }, status: :ok
    end
  end
end
