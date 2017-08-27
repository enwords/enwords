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
    @words = Word::GetByStatus.run!(params.merge(user: current_user))
                              .paginate(page: params[:page], per_page: 20)
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
    if params[:ids] && params[:commit] =~ /to_training/
      Training::Create.run(word_ids:      params[:ids],
                           training_type: params[:commit].gsub(/to_training_/, ''),
                           user:          current_user,
                           words_learned: @learned_words_count)
      redirect_to training_path
    elsif params[:ids] && params[:commit] =~ /to_state/
      Word::UpdateState.run(ids:      params[:ids],
                            to_state: params[:commit].gsub(/to_state_/, ''),
                            user:     current_user)
      redirect_to :back, notice: t('words.buttons.state_changed')
    else
      redirect_to :back
    end
  end

  def update_proficiency_level
    Word::UpdateProficiencyLevel.run(user: current_user,
                                     limit: params[:proficiency_level])
    redirect_back(fallback_location: root_path)
  end

  private

  def word_params
    params.require(:word).permit(:id, :language, :word)
  end

  def set_word
    @word = Word.find(params[:id])
  end
end
