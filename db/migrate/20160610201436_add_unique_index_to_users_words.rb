class AddUniqueIndexToUsersWords < ActiveRecord::Migration[5.0]
  def change
    add_index :users_words, [:user_id, :word_id], unique: true
  end
end
