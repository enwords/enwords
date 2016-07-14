class CreateJoinTableSentencesWords < ActiveRecord::Migration[5.0]
  def change
    create_join_table :sentences, :words do |t|
      # t.index [:sentence_id, :word_id]
      # t.index [:word_id, :sentence_id]
    end
    add_index :sentences_words, [:sentence_id, :word_id], unique: true
  end
end
