class CreateSentences < ActiveRecord::Migration[5.0]
  def change
    create_table(:sentences, :id => false) do |t|
      t.integer :id, :primary_key => true, :unique => true , :null => false
      t.string :language, limit: 4
      t.string :sentence
    end
    add_index :sentences, :language
  end
end
