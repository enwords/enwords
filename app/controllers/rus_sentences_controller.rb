class RusSentencesController < ApplicationController
  before_action :set_rus_sentence, only: [:show, :edit, :update, :destroy]

  # GET /rus_sentences
  # GET /rus_sentences.json
  def index
    @rus_sentences = RusSentence.all
  end

  # GET /rus_sentences/1
  # GET /rus_sentences/1.json
  def show
  end

  # GET /rus_sentences/new
  def new
    @rus_sentence = RusSentence.new
  end

  # GET /rus_sentences/1/edit
  def edit
  end

  # POST /rus_sentences
  # POST /rus_sentences.json
  def create
    @rus_sentence = RusSentence.new(rus_sentence_params)

    respond_to do |format|
      if @rus_sentence.save
        format.html { redirect_to @rus_sentence, notice: 'Rus sentence was successfully created.' }
        format.json { render :show, status: :created, location: @rus_sentence }
      else
        format.html { render :new }
        format.json { render json: @rus_sentence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rus_sentences/1
  # PATCH/PUT /rus_sentences/1.json
  def update
    respond_to do |format|
      if @rus_sentence.update(rus_sentence_params)
        format.html { redirect_to @rus_sentence, notice: 'Rus sentence was successfully updated.' }
        format.json { render :show, status: :ok, location: @rus_sentence }
      else
        format.html { render :edit }
        format.json { render json: @rus_sentence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rus_sentences/1
  # DELETE /rus_sentences/1.json
  def destroy
    @rus_sentence.destroy
    respond_to do |format|
      format.html { redirect_to rus_sentences_url, notice: 'Rus sentence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rus_sentence
      @rus_sentence = RusSentence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rus_sentence_params
      params.require(:rus_sentence).permit(:id, :sentence)
    end
end
