class WordsController < ApplicationController
  before_action :authenticate_user!


  def word_action
    parameter = params[:commit]
    case parameter
      when 'Добавить в изучаемые'
        set_word_status false
        redirect_to(:back)
      when 'Добавить в выученные'
        set_word_status true
        redirect_to(:back)
      when 'Добавить в неопределенные'
        delete_word_status
        redirect_to(:back)
      when 'Тренировать'
        set_training
        redirect_to(practice_path)
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
  end

  def practice
    @sentences = Sentence.where(id: Training.select(:sentence_id).where(user: current_user)).includes(:audio).
        paginate(page: params[:page], per_page: 1)
  end

  def delete_word_status
    Wordbook.delete_all(user_id: current_user, word_id: params[:words_ids])
  end

  def set_word_status(bool)
    unless params[:words_ids].nil?
      params[:words_ids].each do |wid|
        if Wordbook.find_by(user_id: current_user.id, word_id: wid).nil?
          Wordbook.create!(user_id: current_user.id, word_id: wid, learned: bool)
        else
          Wordbook.where(user_id: current_user, word_id: params[:words_ids]).update_all(learned: bool)
        end
      end
    end
  end

  # GET /words
  # GET /words.json
  def index
    @words = Word.joins(:sentences).where(sentences: {language_id: current_user.language_1_id}).
        group(:id).order(:id).paginate(page: params[:page], per_page: 20)
  end

  # GET /learning
  def learning
    @words = current_user.words.where(wordbooks: {learned: false}).order(:id).
        paginate(page: params[:page], per_page: 20)
  end

  # GET /learned
  def learned
    @words = current_user.words.where(wordbooks: {learned: true}).order(:id).
        paginate(page: params[:page], per_page: 20)
  end

  # GET /unset
  def unset
    @words = Word.joins(:sentences).where(sentences: {language_id: current_user.language_1_id}).
        where.not(id: Wordbook.select(:word_id).where(user: current_user)).group(:id).order(:id).
        paginate(page: params[:page], per_page: 20)
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def word_params
    params.require(:word).permit(:id, :word)
  end
end