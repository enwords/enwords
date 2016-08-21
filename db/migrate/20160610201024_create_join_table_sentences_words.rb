class CreateJoinTableSentencesWords < ActiveRecord::Migration[5.0]
  def change
    create_join_table :words, :sentences  do |t|
      # t.index [:sentence_id, :word_id]
      # t.index [:word_id, :sentence_id]
    end
    add_index :sentences_words, [:word_id, :sentence_id], unique: true
  end
end
