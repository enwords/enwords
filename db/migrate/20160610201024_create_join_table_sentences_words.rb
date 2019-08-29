class CreateJoinTableSentencesWords < ActiveRecord::Migration[5.0]
  def change
    create_join_table :words, :sentences
    add_index :sentences_words, %i[word_id sentence_id], unique: true
  end
end
