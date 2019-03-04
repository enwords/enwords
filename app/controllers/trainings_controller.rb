class TrainingsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_current_training

  def show
    case current_training
    when RepeatingTraining, SpellingTraining, GrammarTraining
      @sentences  =
        current_training.sentences.paginate(page: params[:page], per_page: 1)
      @words      = current_training.words.pluck(:value)
      @page_count = @sentences.total_pages
    when MnemoTraining
      @words =
        current_training.words.paginate(page: params[:page], per_page: 1)
      @page_count = @words.total_pages
    end

    current_training.update!(current_page: (params[:page] || 1))
  end

  def words_from_sentence
    @words_from_sentence = Word::FromSentence.run!(params.merge(user: current_user))
    render layout: false
  rescue
    render nothing: true
  end

  def change_status
    to_state =
      case params[:status]
      when 'true'  then 'learned'
      when 'false' then 'learning'
      end

    updating =
      Word::UpdateState.run(
        ids:      [params[:id]],
        to_state: to_state,
        user:     current_user
      )

    if updating.valid?
      render json: updating.result, status: :ok
    else
      render json: updating.errors, status: :unprocessable_entity
    end
  end

  def result
    @learned_words_count_training =
      [0, @learned_words_count - current_training.words_learned].max
  end

  def repeat
    current_training.update!(words_learned: @learned_words_count)
    redirect_to training_path
  end

  private

  def current_training
    @current_training ||= current_user.training
  end

  def check_current_training
    redirect_to root_path unless current_training
  end
end
