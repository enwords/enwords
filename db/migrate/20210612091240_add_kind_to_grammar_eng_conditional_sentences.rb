class AddKindToGrammarEngConditionalSentences < ActiveRecord::Migration[5.2]
  def change
    add_column :grammar_eng_conditional_sentences, :kind, :integer
  end
end
