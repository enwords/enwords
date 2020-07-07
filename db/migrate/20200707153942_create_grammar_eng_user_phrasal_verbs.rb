class CreateGrammarEngUserPhrasalVerbs < ActiveRecord::Migration[5.2]
  def change
    create_table :grammar_eng_user_phrasal_verbs, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :phrasal_verb,
                   foreign_key: { to_table: :grammar_eng_phrasal_verbs },
                   null: false,
                   class_name: 'Grammar::Eng::PhrasalVerb',
                   type: :uuid
      t.timestamps
    end
    add_index :grammar_eng_user_phrasal_verbs,
              %i[user_id phrasal_verb_id],
              unique: true,
              name: :index_user_on_phrasal_verb
  end
end
