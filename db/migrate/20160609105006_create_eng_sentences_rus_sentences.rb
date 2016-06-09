class CreateEngSentencesRusSentences < ActiveRecord::Migration[5.0]
  def change
    create_table(:eng_sentences_rus_sentences, id: false) do |t|
      t.references :eng_sentence, foreign_key: true
      t.references :rus_sentence, foreign_key: true
    end
  end
end
