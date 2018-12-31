module Admin
  class SentencesController < AdminController
    before_action :authenticate_user!
    before_action :set_sentence, only: %i[show edit update destroy]

    def index
      @sentences = Sentence.order(:id).paginate(page: params[:page], per_page: 20)
    end

    def show; end

    def new
      @sentence = Sentence.new
    end

    def edit; end

    def create
      @sentence = Sentence.new(sentence_params)

      respond_to do |format|
        if @sentence.save
          format.html { redirect_to @sentence, notice: 'Sentence was successfully created.' }
          format.json { render :show, status: :created, location: @sentence }
        else
          format.html { render :new }
          format.json { render json: @sentence.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @sentence.update(sentence_params)
          format.html { redirect_to admin_sentence_path(@sentence), notice: 'Sentence was successfully updated.' }
          format.json { render :show, status: :ok, location: @sentence }
        else
          format.html { render :edit }
          format.json { render json: @sentence.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @sentence.destroy
      respond_to do |format|
        format.html { redirect_to admin_sentences_path, notice: 'Sentence was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    def set_sentence
      @sentence = Sentence.find(params[:id])
    end

    def sentence_params
      params.require(:sentence).permit(:id, :language, :sentence)
    end
  end
end
