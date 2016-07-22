class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.where(user: current_user).order(:id).
        paginate(page: params[:page], per_page: 20)
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    unless @article.user == current_user
      redirect_to articles_path
    end
  end

  # GET /articles/new
  def new

    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @article.language = current_user.learning_language
    @article.user = current_user

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }

        count_words_in_text

      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def count_words_in_text
    text = @article.content.downcase.gsub(/[[:punct:]\d]/, '')
    words = text.split(" ")
    frequencies = Hash.new(0)
    words.each { |word| frequencies[word] += 1 }
    create_words_articles(frequencies)

  end

  def create_words_articles(frequencies)
    @article.words = Word.where(word: frequencies.collect { |a, b| a },
                             language: current_user.learning_language)
    @article.words.each { |word| WordInArticle.where(article_id: @article.id, word_id: word.id).update_all(frequency: frequencies[word.word]) }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit(:content, :title)
  end
end
