class WordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  # GET /words.json
  def index
    # @words = Word.all
    @words = Word.joins(:users).where(users: {id: current_user})
  end

  def set
    # UsersWords.create!(user_id: current_user, word_id: params[:words_ids], learned: true)
    ActiveRecord::Base.connection.execute("insert into users_words (word_id, user_id, learned) values (?, ?, ?);",
                                          params[:words_ids], current_user, true)
    redirect_to(:back)
  end

  def set_learned
    # mark selected words as learned
    UsersWords.where(user_id: current_user, word_id: params[:words_ids]).update_all(learned: true)
    redirect_to(:back)
  end

  def set_learning
    # mark selected words as learning
    UsersWords.where(user_id: current_user, word_id: params[:words_ids]).update_all(learned: false)
    redirect_to(:back)
  end

  def unset
    # @words = Word.joins(:users).where(users: { id: current_user})
    @words = Word.left_joins(:users).where('user_id != ?', current_user)
  end

  def learned
    @words = Word.joins(:users).
        where(users: {id: current_user}, users_words: {learned: true})
  end

  def learning
    @words = Word.joins(:users).
        where(users: {id: current_user}, users_words: {learned: false})
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
