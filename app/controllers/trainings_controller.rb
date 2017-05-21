class TrainingsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_training, only: %i[show change_status result]

  def show
    @sentences  = Sentence.where(id: current_training.sentence_ids).order(:id)
                          .paginate(page: params[:page], per_page: 1)
    current_training.update_attributes(current_page: (params[:page] || 1))
    @page_count = @sentences.total_pages
  end

  def words_from_sentence
    @words_from_sentence = ActiveRecord::Base.connection.execute(words_from_sentence_sql)
    render layout: false
  rescue
    render nothing: true
  end

  def change_status
    to_state = case params[:status]
               when 'unknown' then 'learned'
               when 'true'    then 'learning'
               when 'false'   then 'learned'
               end
    updating = Word::UpdateState.run(ids: [params[:id]], to_state: to_state, user: current_user)
    if updating.valid?
      render json: updating.result, status: :ok
    else
      render json: updating.errors, status: :unprocessable_entity
    end
  end

  def result
    @learned_words_count_training = [0, @learned_words_count - current_training.words_learned].max
  end

  private

  def current_training
    @training ||= current_user.training
  end

  def words_from_sentence_sql
    "SELECT words.*, learned FROM words
     JOIN sentences_words ON sentences_words.word_id = words.id
     JOIN sentences ON sentences.id = sentences_words.sentence_id
     LEFT JOIN word_statuses ON word_statuses.word_id = words.id
     WHERE sentences.id = #{params[:id]}
     AND (word_statuses.user_id = #{current_user.id} OR word_statuses.user_id IS NULL)
     ORDER BY words.id"
  end
end
