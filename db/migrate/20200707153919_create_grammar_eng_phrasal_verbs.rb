class CreateGrammarEngPhrasalVerbs < ActiveRecord::Migration[5.2]
  def change
    create_table :grammar_eng_phrasal_verbs, id: :uuid do |t|
      t.string :value, null: false
      t.integer :weight, null: false, default: 1
      t.timestamps
    end
    add_index :grammar_eng_phrasal_verbs, :value, unique: true
  end
end
