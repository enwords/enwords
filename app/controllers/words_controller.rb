class WordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_word, only: [:show, :edit, :update, :destroy]


  # GET /words/new
  def new
    @word = Word.new
  end

  # POST /words
  # POST /words.json
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

  # GET /words/1
  # GET /words/1.json
  def show
  end

  # GET /words/1/edit
  def edit
  end

  # GET /words
  def index
    if params[:status]
      case params[:status]
        when 'learning'
          @title = 'Изучаемые слова'
          learned_and_learning(false)
        when 'learned'
          @title = 'Выученные слова'
          learned_and_learning(true)
        when 'unknown'
          @title = 'Неизвестные слова'
          unknown
        when 'all'
          @title = 'Все слова'
          all
      end
    elsif params[:search]
      @title = 'Результат поиска'
      word_search
    elsif params[:article]
      @title = 'Слова в тексте'
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
    redirect_to words_path, :notice => "Word deleted."
  end

  def word_action
    if params[:ids]
      case params[:commit]
        when 'to_learning'
          set_word_status false
        when 'to_learned'
          set_word_status true
        when 'to_unknown'
          delete_word_status
        when 'to_training'
          set_training
        else
          redirect_to(root_path)
      end
    end
  end

  def training
    @sentences = Sentence.where(id: Training.select(:sentence_id).where(user: current_user)).includes(:audio).group(:id).
        paginate(page: params[:page], per_page: 1)
  end

  def create_or_update_word_status(word_id=params[:word_id], bool=params[:bool])
    begin
      WordStatus.create!(user_id: current_user.id, word_id: word_id, learned: bool)
    rescue
      WordStatus.where(user_id: current_user, word_id: word_id).update_all(learned: bool)
    end
  end

  private

  def words_in_text
    @words = Word.select('words.id', 'words.word', 'word_in_articles.frequency').joins(sentences: :translations).joins(:word_in_articles).
        where(words: {language: current_user.learning_language},
              sentences: {language: current_user.learning_language},
              translations_sentences: {language: current_user.native_language},
              word_in_articles: {article_id: params[:article]})
                 .where.not(words: {id: WordStatus.select(:word_id).where(user_id: current_user.id,
                                                                          learned: true)}).
        group('words.id, word_in_articles.frequency').order('word_in_articles.frequency desc').paginate(page: params[:page], per_page: 20)
  end

  def set_word_status(bool)
    params[:ids].each do |wid|
      create_or_update_word_status(wid, bool)
    end
    redirect_to(:back)
  end

  def set_training
    Training.delete_all(user_id: current_user)
    arr = []
    val = []

    if current_user.diversity_enable
      params[:ids].each do |wid|
        arr << Sentence.select(:id).joins(:sentences_words).joins(:translations).where(sentences_words: {word_id: wid}).
            where(sentences_words: {word_id: wid},
                  translations_sentences: {language: current_user.native_language}).order("RANDOM()").
            limit(current_user.sentences_number)
      end
    else
      params[:ids].each do |wid|
        arr << Sentence.select(:id).joins(:sentences_words).joins(:translations).left_joins(:audio).
            where(sentences_words: {word_id: wid},
                  translations_sentences: {language: current_user.native_language}).
            order('audios.sentence_id ASC').limit(current_user.sentences_number)
      end
    end

    arr.each do |sentences_arr|
      sentences_arr.each do |sen|
        val << {user_id: current_user.id, sentence_id: sen.id}
      end
    end
    Training.create! val

    redirect_to(training_path)
  end

  def delete_word_status
    WordStatus.delete_all(user_id: current_user, word_id: params[:ids])
    redirect_to(:back)
  end

  def words_with_status(bool)
    current_user.words.where(language: current_user.learning_language).where(word_statuses: {learned: bool})
  end

  def words_without_status
    Word.joins(sentences: :translations).where(words: {language: current_user.learning_language},
                                               sentences: {language: current_user.learning_language},
                                               translations_sentences: {language: current_user.native_language})
  end

  def learned_and_learning(bool)
    @words = words_with_status(bool).order(:id).paginate(page: params[:page], per_page: 20)
  end

  def all
    @words = words_without_status.group(:id).order(:id).paginate(page: params[:page], per_page: 20)
  end

  def unknown
    @words = words_without_status.where.not(id: WordStatus.select(:word_id).where(user: current_user)).group(:id).order(:id).
        paginate(page: params[:page], per_page: 20)
  end

  def word_search
    @words = words_without_status.where('word LIKE ?', "%#{params[:search].downcase}%").group(:id).order(:id).
        paginate(page: params[:page], per_page: 20)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def word_params
    params.require(:word).permit(:id, :language, :word)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_word
    @word = Word.find(params[:id])
  end
end