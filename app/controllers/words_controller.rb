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
    @words = if params[:status]
               case params[:status]
               when 'learning'  then learning
               when 'learned'   then learned
               when 'unknown'   then unknown
               when 'available' then available
               when 'skyeng'    then skyeng
               end
             elsif params[:search]     then searching
             elsif params[:article]    then words_from_article
             elsif current_user.admin? then admining
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

  private

  def words_from_article
    word_ids = Hash[Article.find(params[:article]).frequency.sort_by { |k, v| v }.reverse].keys
    @words   = Word.where(id: word_ids)
                   .where.not(id: WordStatus.select(:word_id).where(user: current_user, learned: true))
                   .order("position(id::text in '#{word_ids.join(', ')}')").paginate(page: params[:page], per_page: 20)
  end

  def available
    Word.where(language: current_user.learning_language)
        .group(:id).order(:id).paginate(page: params[:page], per_page: 20)
  end

  def learned
    current_user.words.where(language: current_user.learning_language).where(word_statuses: { learned: true })
                .order(:id).paginate(page: params[:page], per_page: 20)
  end

  def learning
    current_user.words.where(language: current_user.learning_language).where(word_statuses: { learned: false })
                .order(:id).paginate(page: params[:page], per_page: 20)
  end

  def unknown
    Word.where(words: { language: current_user.learning_language })
        .where.not(id: WordStatus.select(:word_id).where(user: current_user)).group(:id)
        .order(:id).paginate(page: params[:page], per_page: 20)
  end

  def searching
    Word.where(language: current_user.learning_language).where('word LIKE ?', "%#{params[:search].strip.downcase}%")
        .group(:id).order(:id).paginate(page: params[:page], per_page: 20)
  end

  def admining
    Word.all.order(:id).paginate(page: params[:page], per_page: 20)
  end

  def skyeng
    skyeng_words = Api::Skyeng.learning_words(email: current_user.skyeng_setting.email,
                                              token: current_user.skyeng_setting.token)

    x = skyeng_words.flat_map { |word| word.downcase.split }.uniq

    Word.where(language: current_user.learning_language,
               word: x)
        .where.not(id: learned.pluck(:id))
        .group(:id)
        .order(:id)
        .paginate(page: params[:page], per_page: 20)
  end

  def word_params
    params.require(:word).permit(:id, :language, :word)
  end

  def set_word
    @word = Word.find(params[:id])
  end
end
