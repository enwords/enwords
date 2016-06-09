class CreateEngWordsWordCollections < ActiveRecord::Migration[5.0]
  def change
    create_table(:eng_words_word_collections, id: false) do |t|
      t.references :eng_word, foreign_key: true
      t.references :word_collection, foreign_key: true
    end
  end
end
