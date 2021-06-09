class CreateGrammarEngConditionalSentences < ActiveRecord::Migration[5.2]
  def change
    create_table :grammar_eng_conditional_sentences, id: :uuid do |t|
      t.string :value
      t.string :translation
      t.timestamps
    end
  end
end
