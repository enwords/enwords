class AddUniqueIndexToEngWordsUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :eng_words_users, [:eng_word_id, :user_id], unique: true
  end
end
