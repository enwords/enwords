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
    redirect_to words_path, :notice => "Word deleted."
  end

  #Actions for the buttons
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
          set_last_training(:training)
          set_training
        when 'to_training_spelling'
          set_last_training(:training_spelling)
          set_training
        else
          redirect_to(root_path)
      end
    else
      redirect_to :back
    end
  end

  #Training page
  def training
    current_user.update(training_page: params[:page])
    @sentences= current_user.studying_sentences.order(:id).paginate(page: params[:page], per_page: 1)
    @page_sum = @sentences.total_pages
    @words = current_user.studying_words
  end

  def words_in_sentence
    current_training = current_user.last_training
    case current_training
      when 'training'
        @words = []
      when 'training_spelling'
        @words = current_user.studying_words
    end
    sentence = Sentence.find(params[:id])
    @words_in_sentence = sentence.words
    render :layout => false
  end

  #Action to the buttons on training page
  def set_word_status_training
    create_or_update_word_status(params[:word_id], params[:bool])
    # redirect_to :back
  end

  private

  #Words contained in the loaded text
  def words_in_text
    @words = Word.joins(:word_in_articles).
        where(words: {language: current_user.learning_language},
              word_in_articles: {article_id: params[:article]})
                 .where.not(words: {id: WordStatus.select(:word_id).where(user: current_user, learned: true)})
                 .order('word_in_articles.frequency desc, words.id asc').paginate(page: params[:page], per_page: 20)
  end

  #Update word status
  def create_or_update_word_status(word_id, bool)
    begin
      WordStatus.create!(user_id: current_user.id, word_id: word_id, learned: bool)
    rescue
      WordStatus.where(user_id: current_user, word_id: word_id).update_all(learned: bool)
    end
  end

  #Sends selected words into learned or learning
  def set_word_status(bool)
    params[:ids].values.each do |wid|
      create_or_update_word_status(wid, bool)
    end

    redirect_to :back, notice: t("words.buttons.added_to_learning") if !bool
    redirect_to :back, notice: t("words.buttons.added_to_learned") if bool

  end

  def update_learned_words_count
    learned_words_count = current_user.words.where(language: current_user.learning_language).where(word_statuses: {learned: true}).count
    current_user.update(:learned_words_count => learned_words_count)
  end

  #Sends selected words into training
  def set_training
    update_learned_words_count
    set_training_words
    set_training_sentences
    redirect_to(training_path)
  end

  #Set type of training there will be a link on the navigation bar
  def set_last_training(arg)
    current_user.update(last_training: arg)
  end

  #Insert into database words that the user has selected for the study
  def set_training_words
    current_user.studying_words = Word.where(id: params[:ids].values)
  end

  #Find a appropriate sentences to the studied words
  def set_training_sentences
    lim ||= current_user.sentences_number

    if current_user.diversity_enable
      arr = Sentence.select("(array_agg(DISTINCT(sentences.id)))[1:100]").joins(:sentences_words).
          where(sentences_words: {word_id: current_user.studying_words}).group('sentences_words.word_id')
    else
      arr = Sentence.select("(array_agg(DISTINCT(sentences.id)))[1:100]").joins(:sentences_words).joins(:translations).
          # where(sentences_words: {word_id: TrainingWord.select(:word_id).where(user: current_user)},
          where(sentences_words: {word: current_user.studying_words},
                translations_sentences: {language: current_user.native_language}).group('sentences_words.word_id')
    end

    sentences_ids = []
    arr.each do |row|
      row['array_agg'].sample(lim).each do |id|
        sentences_ids << id
      end
    end

    current_user.studying_sentences.delete_all
    sentences_ids.uniq.each { |id| TrainingSentence.create!(user: current_user, sentence_id: id) }
  end

  #Delete word_status
  def delete_word_status
    WordStatus.delete_all(user_id: current_user, word_id: params[:ids].values)
    redirect_to :back, notice: t("words.buttons.added_to_unknown")
  end

  #Get learned and learning words of current learning language without pagination
  def words_with_status(bool)
    current_user.words.where(language: current_user.learning_language).where(word_statuses: {learned: bool})
  end

  #Get unknown words of current learning language without pagination
  def words_without_status
    # Word.joins(sentences: :translations).where(words: {language: current_user.learning_language},
    #                                            translations_sentences: {language: current_user.native_language})

    Word.where(words: {language: current_user.learning_language})
  end

  #Get learned and learning words of current learning language
  def learned_and_learning(bool)
    @count = current_user.words.where(language: current_user.learning_language).where(word_statuses: {learned: bool}).count
    @words = words_with_status(bool).order(:id).paginate(page: params[:page], per_page: 20)
  end

  #Get all words of current learning language
  def all
    @words = words_without_status.group(:id).order(:id).paginate(page: params[:page], per_page: 20)
  end

  #Get unknown words of current learning language
  def unknown
    @words = words_without_status.where.not(id: WordStatus.select(:word_id).where(user: current_user)).group(:id).order(:id).
        paginate(page: params[:page], per_page: 20)
  end

  #Get words of current learning language that a user is looking for
  def word_search
    @words = words_without_status.where('word LIKE ?', "%#{params[:search].downcase.strip}%").group(:id).order(:id).
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