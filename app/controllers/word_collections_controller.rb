class WordCollectionsController < ApplicationController
  before_action :set_word_collection, only: [:show, :edit, :update, :destroy]

  # GET /word_collections
  # GET /word_collections.json
  def index
    @word_collections = WordCollection.all
  end

  # GET /word_collections/1
  # GET /word_collections/1.json
  def show
  end

  # GET /word_collections/new
  def new
    @word_collection = WordCollection.new
  end

  # GET /word_collections/1/edit
  def edit
  end

  # POST /word_collections
  # POST /word_collections.json
  def create
    @word_collection = WordCollection.new(word_collection_params)

    respond_to do |format|
      if @word_collection.save
        format.html { redirect_to @word_collection, notice: 'Word collection was successfully created.' }
        format.json { render :show, status: :created, location: @word_collection }
      else
        format.html { render :new }
        format.json { render json: @word_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /word_collections/1
  # PATCH/PUT /word_collections/1.json
  def update
    respond_to do |format|
      if @word_collection.update(word_collection_params)
        format.html { redirect_to @word_collection, notice: 'Word collection was successfully updated.' }
        format.json { render :show, status: :ok, location: @word_collection }
      else
        format.html { render :edit }
        format.json { render json: @word_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /word_collections/1
  # DELETE /word_collections/1.json
  def destroy
    @word_collection.destroy
    respond_to do |format|
      format.html { redirect_to word_collections_url, notice: 'Word collection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word_collection
      @word_collection = WordCollection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_collection_params
      params.require(:word_collection).permit(:user_id)
    end
end
