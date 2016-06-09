class CreateEngWordsEngSentences < ActiveRecord::Migration[5.0]
  def change
    create_table(:eng_words_eng_sentences, id: false) do |t|
      t.references :eng_word, foreign_key: true
      t.references :eng_sentence, foreign_key: true
    end
  end
end
