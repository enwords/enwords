class CreateGrammarEngUserIdioms < ActiveRecord::Migration[5.2]
  def change
    create_table :grammar_eng_user_idioms, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :idiom,
                   foreign_key: { to_table: :grammar_eng_idioms },
                   null: false,
                   class_name: 'Grammar::Eng::Idiom',
                   type: :uuid
      t.timestamps
    end
    add_index :grammar_eng_user_idioms, %i[user_id idiom_id], unique: true
  end
end
