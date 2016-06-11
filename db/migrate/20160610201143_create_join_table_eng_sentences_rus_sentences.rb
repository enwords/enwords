class CreateJoinTableEngSentencesRusSentences < ActiveRecord::Migration[5.0]
  def change
    create_join_table :eng_sentences, :rus_sentences do |t|
      # t.index [:eng_sentence_id, :rus_sentence_id]
      # t.index [:rus_sentence_id, :eng_sentence_id]
    end
  end
end
