class DropOldTrainingTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :training_sentences
    drop_table :training_words
    drop_table :word_in_articles
  end
end
