class CreateGrammarEngPhrasalVerbMeanings < ActiveRecord::Migration[5.2]
  def change
    create_table :grammar_eng_phrasal_verb_meanings, id: :uuid do |t|
      t.string :value, null: false
      t.string :example
      t.belongs_to :phrasal_verb,
                   foreign_key: { to_table: :grammar_eng_phrasal_verbs },
                   null: false,
                   class_name: 'Grammar::Eng::PhrasalVerb',
                   type: :uuid
      t.timestamps
    end
  end
end
