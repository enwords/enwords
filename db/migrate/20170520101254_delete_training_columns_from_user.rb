class DeleteTrainingColumnsFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :last_training_type
    remove_column :users, :training_page
    remove_column :users, :learned_words_count
  end
end
