class AddDefaultUserParams < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :role, :integer, limit: 2, default: 'user', null: false
    change_column :users, :sentences_number, :integer, limit: 2, default: 5, null: false
    change_column :users, :audio_enable, :boolean, default: false
    change_column :users, :diversity_enable, :boolean, default: false
    change_column :users, :learned_words_count, :integer, default: 0, null: false
    rename_column :users, :last_training, :last_training_type
  end
end
