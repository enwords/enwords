class EngWordsController < ApplicationController
  before_action :set_eng_word, only: [:show, :edit, :update, :destroy]

  # GET /eng_words
  # GET /eng_words.json
  def index
    @eng_words = EngWord.all
  end

  def lwords
    @eng_words = EngWord.all
    # @tt = EngWordsUsers.where(user_id: current_user, is_learned: false)
    # @eng_words = EngWord.where(word_id: @tt)


  end

  # GET /eng_words/1
  # GET /eng_words/1.json
  def show
  end

  # GET /eng_words/new
  def new
    @eng_word = EngWord.new
  end

  # GET /eng_words/1/edit
  def edit
  end

  # POST /eng_words
  # POST /eng_words.json
  def create
    @eng_word = EngWord.new(eng_word_params)

    respond_to do |format|
      if @eng_word.save
        format.html { redirect_to @eng_word, notice: 'Eng word was successfully created.' }
        format.json { render :show, status: :created, location: @eng_word }
      else
        format.html { render :new }
        format.json { render json: @eng_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eng_words/1
  # PATCH/PUT /eng_words/1.json
  def update
    respond_to do |format|
      if @eng_word.update(eng_word_params)
        format.html { redirect_to @eng_word, notice: 'Eng word was successfully updated.' }
        format.json { render :show, status: :ok, location: @eng_word }
      else
        format.html { render :edit }
        format.json { render json: @eng_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eng_words/1
  # DELETE /eng_words/1.json
  def destroy
    @eng_word.destroy
    respond_to do |format|
      format.html { redirect_to eng_words_url, notice: 'Eng word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eng_word
      @eng_word = EngWord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def eng_word_params
      params.require(:eng_word).permit(:id, :word)
    end



end
