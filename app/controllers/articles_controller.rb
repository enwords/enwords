class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def delete_selected
    current_user.articles.where(id: params[:ids]).delete_all
    redirect_to articles_path, notice: t('articles.delete')
  end

  def index
    @articles = current_user.articles.where(language: current_user.learning_language).order(:id)
                            .paginate(page: params[:page], per_page: 15)
  end

  def new
    @article = Article.new
  end

  def show; end

  def edit; end

  def create
    @article      = Article.new(article_params)
    @article.user = current_user

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_path(@article), notice: t('texts.text_created') }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_path(@article), notice: t('texts.text_updated') }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_path, notice: t('texts.text_deleted') }
      format.json { head :no_content }
    end
  end

  private

  def set_article
    @article = current_user.articles.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:content, :title, :language)
  end
end
