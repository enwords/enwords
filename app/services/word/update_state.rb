class Word::UpdateState < ActiveInteraction::Base
  array  :ids
  string :to_state
  object :user

  validates :ids, :to_state, :user, presence: true

  def execute
    case to_state
    when 'learning' then change_learning_state false
    when 'learned'  then change_learning_state true
    when 'unknown'  then update_state_to_unknown
    else
      raise "Unknown state #{to_state}"
    end
    WordStatus.where(user_id: user, word_id: ids)
  end

  private

  def change_learning_state(bool)
    ids.each { |id| create_or_update_state(id, bool) }
  end

  def create_or_update_state(id, bool)
    WordStatus.create!(user_id: user.id, word_id: id, learned: bool)
  rescue
    WordStatus.where(user_id: user, word_id: id).update_all(learned: bool)
  end

  def update_state_to_unknown
    WordStatus.delete_all(user: user, word_id: ids)
  end
end