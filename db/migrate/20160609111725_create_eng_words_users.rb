class CreateEngWordsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table(:eng_words_users, id: false) do |t|
      t.references :eng_word, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :is_learned
    end
  end
end
