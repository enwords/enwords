class EngSentencesController < ApplicationController
  before_action :set_eng_sentence, only: [:show, :edit, :update, :destroy]

  # GET /eng_sentences
  # GET /eng_sentences.json
  def index
    @eng_sentences = EngSentence.all
  end

  # GET /eng_sentences/1
  # GET /eng_sentences/1.json
  def show
  end

  # GET /eng_sentences/new
  def new
    @eng_sentence = EngSentence.new
  end

  # GET /eng_sentences/1/edit
  def edit
  end

  # POST /eng_sentences
  # POST /eng_sentences.json
  def create
    @eng_sentence = EngSentence.new(eng_sentence_params)

    respond_to do |format|
      if @eng_sentence.save
        format.html { redirect_to @eng_sentence, notice: 'Eng sentence was successfully created.' }
        format.json { render :show, status: :created, location: @eng_sentence }
      else
        format.html { render :new }
        format.json { render json: @eng_sentence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eng_sentences/1
  # PATCH/PUT /eng_sentences/1.json
  def update
    respond_to do |format|
      if @eng_sentence.update(eng_sentence_params)
        format.html { redirect_to @eng_sentence, notice: 'Eng sentence was successfully updated.' }
        format.json { render :show, status: :ok, location: @eng_sentence }
      else
        format.html { render :edit }
        format.json { render json: @eng_sentence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eng_sentences/1
  # DELETE /eng_sentences/1.json
  def destroy
    @eng_sentence.destroy
    respond_to do |format|
      format.html { redirect_to eng_sentences_url, notice: 'Eng sentence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eng_sentence
      @eng_sentence = EngSentence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def eng_sentence_params
      params.require(:eng_sentence).permit(:id, :sentence)
    end
end
