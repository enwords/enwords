class WordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_word, only: %i[show edit update destroy]

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  def show; end

  def edit; end

  def index
    if params[:status]
      case params[:status]
      when 'learning'
        learned_and_learning(false)
      when 'learned'
        learned_and_learning(true)
      when 'unknown'
        unknown
      when 'all'
        all
      end
    elsif params[:search]
      word_search
    elsif params[:article]
      words_in_text
    elsif current_user.admin?
      @words = Word.all.order(:id).paginate(page: params[:page], per_page: 20)
    end
  end

  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @word.destroy
    redirect_to words_path, notice: 'Word deleted'
  end

  def word_action
    if params[:ids] && params[:commit] =~ /training/
      Word::SetTraining.run(word_ids: params[:ids], training_type: params[:commit], user: current_user)
      redirect_to training_path
    elsif params[:ids] && params[:commit] =~ /state/
      Word::UpdateState.run(ids: params[:ids], to_state: params[:commit], user: current_user)
      redirect_to :back, notice: t('words.buttons.state_changed')
    else
      redirect_to :back
    end
  end

  def training
    current_user.update(training_page: params[:page])
    @sentences = current_user.studying_sentences.order(:id).paginate(page: params[:page], per_page: 1)
    @page_sum  = @sentences.total_pages
    @words     = current_user.studying_words
  end

  def words_in_sentence
    @words             = []
    @word              = current_user.studying_words if current_user.last_training_type == 'training_spelling'
    @words_in_sentence = Sentence.find(params[:id]).words
    render layout: false
  end

  def set_word_status_training
    to_state = case params[:bool]
               when 'true'  then 'to_learned_state'
               when 'false' then 'to_learning_state'
               else 'to_unknown_state'
               end
    Word::UpdateState.run(ids: [params[:word_id]], to_state: to_state, user: current_user)
  end

  private

  def words_in_text
    @words = Word.joins(:word_in_articles).where(words: { language: current_user.learning_language },
                                                 word_in_articles: { article_id: params[:article] })
                 .where.not(words: { id: WordStatus.select(:word_id).where(user: current_user, learned: true) })
                 .order('word_in_articles.frequency desc, words.id asc').paginate(page: params[:page], per_page: 20)
  end

  def words_with_status(bool)
    current_user.words.where(language: current_user.learning_language).where(word_statuses: { learned: bool })
  end

  def words_without_status
    Word.where(words: { language: current_user.learning_language })
  end

  def learned_and_learning(bool)
    @count = current_user.words.where(language: current_user.learning_language).where(word_statuses: { learned: bool }).count
    @words = words_with_status(bool).order(:id).paginate(page: params[:page], per_page: 20)
  end

  def all
    @words = words_without_status.group(:id).order(:id).paginate(page: params[:page], per_page: 20)
  end

  def unknown
    @words = words_without_status.where.not(id: WordStatus.select(:word_id).where(user: current_user)).group(:id)
                                 .order(:id).paginate(page: params[:page], per_page: 20)
  end

  def word_search
    @words = words_without_status.where('word LIKE ?', "%#{params[:search].downcase.strip}%").group(:id).order(:id).
      paginate(page: params[:page], per_page: 20)
  end

  def word_params
    params.require(:word).permit(:id, :language, :word)
  end

  def set_word
    @word = Word.find(params[:id])
  end
end