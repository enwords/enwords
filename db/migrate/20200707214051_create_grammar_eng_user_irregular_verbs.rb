class CreateGrammarEngUserIrregularVerbs < ActiveRecord::Migration[5.2]
  def change
    create_table :grammar_eng_user_irregular_verbs, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :irregular_verb,
        foreign_key: { to_table: :grammar_eng_irregular_verbs },
        null: false,
        class_name: 'Grammar::Eng::irregularVerb'
      t.timestamps
    end
    add_index :grammar_eng_user_irregular_verbs,
              %i[user_id irregular_verb_id],
              unique: true,
              name: :index_user_on_irregular_verb
  end
end
