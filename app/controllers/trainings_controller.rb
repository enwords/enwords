class TrainingsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_training, only: %i[show change_status result reset_word_count]

  def show
    @sentences = Sentence.where(id: current_training.sentence_ids).order(:id)
                         .paginate(page: params[:page], per_page: 1)
    @words = Word.where(id: current_training.word_ids).order(:id).pluck(:word)

    current_training.update_attributes(current_page: (params[:page] || 1))
    @page_count = @sentences.total_pages
  end

  def words_from_sentence
    @words_from_sentence =
      Word::FromSentence.run!(params.merge(user: current_user))

    render layout: false
  rescue
    render nothing: true
  end

  def change_status
    to_state = case params[:status]
               when 'true'    then 'learned'
               when 'false'   then 'learning'
               end
    updating = Word::UpdateState.run(ids:      [params[:id]],
                                     to_state: to_state,
                                     user:     current_user)
    if updating.valid?
      render json: updating.result, status: :ok
    else
      render json: updating.errors, status: :unprocessable_entity
    end
  end

  def result
    @learned_words_count_training = [0, @learned_words_count - current_training.words_learned].max
  end

  def repeat
    current_training.update(words_learned: @learned_words_count)
    redirect_to training_path
  end

  private

  def current_training
    @training ||= current_user.training
  end
end
