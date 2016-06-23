class WordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  # GET /words.json
  def index
    @words = Word.all.order(:id)
  end

  def word_action
    parameter = params[:commit]
    case parameter
      when 'Добавить в изучаемые'
        set_word_status false
      when 'Добавить в выученные'
        set_word_status true
      when 'Изучать'
        update_word_status false
      when 'Выучил'
        update_word_status true
      when 'Скрыть'
        delete_word_status
      when 'Тренеровать'
        set_training
      else
        return
    end
  end

  #TODO need optimization
  def set_training
    Training.delete_all(user_id: current_user)
    arr = []
    val = []

    params[:words_ids].each do |wid|
      arr << Sentence.joins(:sentences_words).where(sentences_words: {word_id: wid}).order("RANDOM()").limit(5)
    end

    arr.each do |sentences_arr|
      sentences_arr.each do |sen|
        val << {user_id: current_user.id, sentence_id: sen.id}
      end
    end

    Training.create! val
    redirect_to(practice_path)
  end

  def practice

    # @sentences = Sentence.includes(:audio).select('en.id id, en.sentence sen1, ru.sentence sen2, audio.sentence_id a')
    # .join

    sql = "
SELECT s1.id id, s1.sentence original, s2.sentence translate, audio.sentence_id audio from sentences s1
JOIN links ON links.sentence_1_id = s1.id
JOIN sentences s2 ON links.sentence_2_id = s2.id
JOIN trainings ON trainings.sentence_id = s1.id
LEFT JOIN audio ON audio.sentence_id = s1.id
where user_id = #{current_user.id}
"
    @sentences = ActiveRecord::Base.connection.execute(sql)

  end

  def delete_word_status
    Wordbook.delete_all(user_id: current_user, word_id: params[:words_ids])
    redirect_to(:back)
  end

  def set_word_status(bool)
    val = []
    params[:words_ids].each { |wid|
      val << {user_id: current_user.id, word_id: wid, learned: bool}
    }
    Wordbook.create! val
    redirect_to(:back)
  end

  def update_word_status(bool)
    Wordbook.where(user_id: current_user, word_id: params[:words_ids]).update_all(learned: bool)
    redirect_to(:back)
  end

  def unset
    @words = Word.joins(:sentences).where(sentences: {language_id: current_user.language_1_id }).
        where.not(id: Wordbook.select(:word_id).where(user: current_user)).group(:id).order(:id).paginate(page: params[:page], per_page: 20)
  end

  def learned
    @words = current_user.words.where(wordbooks: {learned: true}).order(:id)
  end

  def learning
    @words = current_user.words.where(wordbooks: {learned: false}).order(:id)
  end

  # GET /words/1
  # GET /words/1.json
  def show
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words
  # POST /words.json
  def create
    word = Word.new(word_params)

    respond_to do |format|
      if word.save
        format.html { redirect_to word, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: word }
      else
        format.html { render :new }
        format.json { render json: word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    respond_to do |format|
      if word.update(word_params)
        format.html { redirect_to word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: word }
      else
        format.html { render :edit }
        format.json { render json: word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    word.destroy
    respond_to do |format|
      format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_word
    @word = Word.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def word_params
    params.require(:word).permit(:id, :word)
  end


end
