class WordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_word_statuses, only: %i[index]

  def index
    @words = Word::ByStatus.run!(params.merge(user: current_user))
                           .paginate(page: params[:page], per_page: 20)
  end

  def word_action
    if params[:ids] && params[:commit] =~ /to_training/
      Training::Create.run(word_ids: params[:ids],
                           training_type: params[:commit].gsub(/to_training_/, ''),
                           user: current_user,
                           words_learned: @learned_words_count)
      redirect_to training_path
    elsif params[:ids] && params[:commit] =~ /to_state/
      Word::UpdateState.run(ids: params[:ids],
                            to_state: params[:commit].gsub(/to_state_/, ''),
                            user: current_user)
      redirect_to :back, notice: t('words.buttons.state_changed')
    else
      redirect_to :back, alert: t('words.buttons.select_words')
    end
  end

  private

  def word_params
    params.require(:word).permit(:id, :language, :word)
  end

  def set_word_statuses
    statuses = current_user.word_statuses
    @learned_ids = statuses.where(learned: true).pluck(:word_id)
    @learning_ids = statuses.where(learned: false).pluck(:word_id)
  end
end
