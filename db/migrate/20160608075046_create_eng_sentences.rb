class CreateEngSentences < ActiveRecord::Migration[5.0]
  def change
    create_table(:eng_sentences, :id => false) do |t|
      t.integer :id, :primary_key => true, :unique => true , :null => false
      t.string :sentence
      t.boolean :audio
    end
  end
end
