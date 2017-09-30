class CreateGrammarEngIrregularVerbs < ActiveRecord::Migration[5.0]
  def change
    create_table :grammar_eng_irregular_verbs do |t|
      t.string :infinitive
      t.jsonb  :simple_past,     default: []
      t.jsonb  :past_participle, default: []
    end
  end
end
